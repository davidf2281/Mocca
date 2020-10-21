//
//  CaptureManager.swift
//
//  Created by David Fearon on 15/07/2019.
//  Copyright © 2019 n/a. All rights reserved.
//

import UIKit
import AVFoundation

struct LogicalCameraDevice: Equatable {
    let type: AVCaptureDevice.DeviceType
    let position: AVCaptureDevice.Position
}

/// A class to handle creation and management of fully configured video and photo capture sessions and related functions.
class DeviceCaptureManager: CaptureManager {

    public var videoPreviewLayer: TestableAVCaptureVideoPreviewLayer? {
        willSet {
            assert(self.videoPreviewLayer == nil, "Video preview layer may be set only once")
        }
    }
    
    public static let supportedCameraDevices = [LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back),
                                                LogicalCameraDevice(type: .builtInWideAngleCamera, position: .back),
                                                LogicalCameraDevice(type: .builtInUltraWideCamera, position: .back)]
    
    public private(set) var captureSession : TestableAVCaptureSession
    public private(set) var activeCaptureDevice : TestableAVCaptureDevice

    private let photoOutput: AVCapturePhotoOutput
    private let videoDataOutput: AVCaptureVideoDataOutput
    private let photoSettings: AVCapturePhotoSettings
    private let resources: Resources
    
    convenience init(resources: Resources) throws {
        
        let startupCamera = LogicalCameraDevice(type: .builtInWideAngleCamera, position: .back)
        
        guard let initialCaptureDevice =
                resources.anyAvailableCamera(preferredDevice: startupCamera,
                                        supportedCameraDevices: Self.supportedCameraDevices)
        else {
            throw CaptureManagerError.captureDeviceNotFound
        }
        
        let videoInput = try AVCaptureDeviceInput(device: initialCaptureDevice as! AVCaptureDevice)
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        let photoOutput = Self.configuredPhotoOutput()
        
        let videoOutput = Self.configuredVideoDataOutput()
                
        try self.init(captureSession: captureSession, photoOutput: photoOutput, videoOutput: videoOutput, initialCaptureDevice: initialCaptureDevice, videoInput: videoInput, resources:resources)
    }
    
    public init(captureSession: TestableAVCaptureSession, photoOutput: AVCapturePhotoOutput, videoOutput: AVCaptureVideoDataOutput, initialCaptureDevice: TestableAVCaptureDevice, videoInput: TestableAVCaptureDeviceInput, resources: Resources) throws {
        
        self.photoOutput =          photoOutput
        self.videoDataOutput =      videoOutput
        self.captureSession =       captureSession
        self.activeCaptureDevice =  initialCaptureDevice
        self.resources = resources
                
        // MARK: Capture-session configuration
        self.captureSession.beginConfiguration()
        
        // MARK: Capture-session inputs
        if self.captureSession.canAddInput(videoInput as! AVCaptureDeviceInput) {
            self.captureSession.addInput(videoInput as! AVCaptureDeviceInput)
        } else {
            throw CaptureManagerError.addVideoInputFailed
        }
        
        // MARK: Capture-sessions outputs
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            throw CaptureManagerError.addPhotoOutputFailed
        }
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        } else {
            throw CaptureManagerError.addVideoDataOutputFailed
        }
        
        // MARK: Photo settings
        self.photoSettings = DeviceCaptureManager.configuredPhotoSettings(for: photoOutput)
        
        captureSession.commitConfiguration()
    }
    
    /// Start the capture session
    public func startCaptureSession () {
        self.captureSession.startRunning()
    }
    
    /// Stop the capture session
    public func stopCaptureSession () {
        self.captureSession.stopRunning()
    }
    
    /// - Returns: A unique copy of current photo settings, without orientation compensation
    public func currentPhotoSettings() -> AVCapturePhotoSettings {
        return AVCapturePhotoSettings(from: self.photoSettings)
    }
    
    /// Instructs the capture manager to capture a photo from the active physical camera.
    /// - Parameter delegate: An object conforming to AVCapturePhotoCaptureDelegate to receive the resulting AVCapturePhoto.
    public func capturePhoto(settings:AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate) {
        
        if let photoOutputConnection = self.photoOutput.connection(with: .video) {
            photoOutputConnection.videoOrientation = Orientation.AVOrientation(for: Orientation.currentInterfaceOrientation())
        }
        
        self.photoOutput.capturePhoto(with: settings, delegate: delegate)
    }
    
    /// Sets the active session's capture device to the physical camera matching the supplied type
    /// - Parameter type: The type of camera to select
    /// - Returns: true if the operation succeeded; false otherwise
    public func selectCamera(type: LogicalCameraDevice) -> Outcome {
        if let device = self.resources.physicalDevice(from: type) {
            self.activeCaptureDevice = device
            return .success
        }
        
        return .failure
    }
    
    public func setSampleBufferDelegate(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
                                 queue callbackQueue: DispatchQueue) {
        self.videoDataOutput.setSampleBufferDelegate(delegate, queue: callbackQueue)
    }
    
    internal class func configuredPhotoOutput() -> AVCapturePhotoOutput {
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = false
        photoOutput.maxPhotoQualityPrioritization = .quality // MARK: TODO: Tests to make sure this has been set before setting settings.photoQualityPrioritization
        return photoOutput
    }
    
    internal class func configuredVideoDataOutput() -> AVCaptureVideoDataOutput {
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [:] // Set the output to receive in device-native format
        return videoDataOutput
    }
    
    internal class func configuredPhotoSettings(for photoOutput:AVCapturePhotoOutput) -> AVCapturePhotoSettings {
        let settings: AVCapturePhotoSettings = photoOutput.availablePhotoCodecTypes.contains(.hevc) ?
            AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.hevc]) :
            AVCapturePhotoSettings()
        
        settings.photoQualityPrioritization = .quality
        settings.flashMode = .off
        
        return settings
    }
}

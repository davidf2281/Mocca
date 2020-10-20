//
//  CaptureManager.swift
//
//  Created by David Fearon on 15/07/2019.
//  Copyright © 2019 n/a. All rights reserved.
//

import UIKit
import AVFoundation

struct CameraDevice: Equatable {
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
    
    public static let supportedCameraDevices = [CameraDevice(type: .builtInTelephotoCamera, position: .back),
                                                CameraDevice(type: .builtInWideAngleCamera, position: .back),
                                                CameraDevice(type: .builtInUltraWideCamera, position: .back)]
    
    public private(set) var captureSession : TestableAVCaptureSession
    public private(set) var activeCaptureDevice : TestableAVCaptureDevice

    private let photoOutput : AVCapturePhotoOutput
    private let photoSettings: AVCapturePhotoSettings
        
    convenience init() throws {
        
        let startupCamera = CameraDevice(type: .builtInWideAngleCamera, position: .back)
        
        guard let initialCaptureDevice =
                Self.anyAvailableCamera(preferredDevice: startupCamera,
                                        supportedCameraDevices: Self.supportedCameraDevices)
        else {
            throw CaptureManagerError.captureDeviceNotFound
        }
        
        let videoInput = try AVCaptureDeviceInput(device: initialCaptureDevice)
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        let photoOutput = Self.configuredPhotoOutput()
        
        try self.init(captureSession: captureSession, output: photoOutput, initialCaptureDevice: initialCaptureDevice, videoInput: videoInput)
    }
    
    public init(captureSession: TestableAVCaptureSession, output: AVCapturePhotoOutput, initialCaptureDevice: TestableAVCaptureDevice, videoInput: TestableAVCaptureDeviceInput) throws {
        
        self.photoOutput =          output
        self.captureSession =       captureSession
        self.activeCaptureDevice =  initialCaptureDevice
        
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
            throw CaptureManagerError.addVideoOutputFailed
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
    public func selectCamera(type: CameraDevice) -> Outcome {
        if let device = DeviceCaptureManager.physicalDevice(from: type) {
            self.activeCaptureDevice = device
            return .success
        }
        
        return .failure
    }
    
    internal class func configuredPhotoOutput() -> AVCapturePhotoOutput {
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = false
        photoOutput.maxPhotoQualityPrioritization = .quality // MARK: TODO: Tests to make sure this has been set before setting settings.photoQualityPrioritization
        return photoOutput
    }
    
    internal class func configuredPhotoSettings(for photoOutput:AVCapturePhotoOutput) -> AVCapturePhotoSettings {
        let settings: AVCapturePhotoSettings = photoOutput.availablePhotoCodecTypes.contains(.hevc) ?
            AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.hevc]) :
            AVCapturePhotoSettings()
        
        settings.photoQualityPrioritization = .quality
        settings.flashMode = .off
        
        return settings
    }
    
    /// Searches for an available physical camera within the supplied array of supported logical camera device types.
    /// - Parameter preferredDevice: The preferred type to return.
    /// - Parameter supportedCameraDevices: An array of CameraDevice
    /// - Returns: A physical camera of the preferred type, the first available if the preferred choice is not found, or nil if none are found.
    private class func anyAvailableCamera(preferredDevice:CameraDevice,
                                          supportedCameraDevices: [CameraDevice]) -> AVCaptureDevice? {
        
        if supportedCameraDevices.contains(preferredDevice) {
            if let device = physicalDevice(from: preferredDevice) {
                return device
            }
        }
        
        for supportedDevice in supportedCameraDevices {
            if let device = DeviceCaptureManager.physicalDevice(from: supportedDevice) {
                return device
            }
        }
        
        return nil
    }
    
    private class func physicalDevice(from logicalDevice: CameraDevice) -> AVCaptureDevice? {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [logicalDevice.type], mediaType: .video, position: logicalDevice.position)
        if let device = session.devices.first {
            return device
        }
        
        return nil
    }
}

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
    
    public var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    public static let supportedCameraDevices = [CameraDevice(type: .builtInTelephotoCamera, position: .back),
                                                CameraDevice(type: .builtInWideAngleCamera, position: .back),
                                                CameraDevice(type: .builtInUltraWideCamera, position: .back)]
    
    private(set) var captureSession : TestableAVCaptureSession
    
    private let photoOutput : AVCapturePhotoOutput
    
    private let photoSettings: AVCapturePhotoSettings
    
    internal var activeCaptureDevice : TestableAVCaptureDevice
    
    public var isExposurePointOfInterestSupported: Bool {
        return self.activeCaptureDevice.isExposurePointOfInterestSupported;
    }
    
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
        
        let photoOutput = AVCapturePhotoOutput()
        
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
        
        // MARK: Capture-session outputs
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = false
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            throw CaptureManagerError.addVideoOutputFailed
        }
        
        // MARK: Photo settings
        self.photoSettings = DeviceCaptureManager.photoSettings(for: photoOutput)
        
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
    public func capturePhoto (delegate: AVCapturePhotoCaptureDelegate) {
        let settings = AVCapturePhotoSettings(from: self.photoSettings)
        if let photoOutputConnection = self.photoOutput.connection(with: .video) {
            photoOutputConnection.videoOrientation = Orientation.AVOrientation(for: Orientation.currentInterfaceOrientation())
        }
        
        self.photoOutput.capturePhoto(with: settings, delegate: delegate)
    }
    
    /// Sets the active session's capture device to the physical camera matching the supplied type
    /// - Parameter type: The type of camera to select
    /// - Returns: true if the operation succeeded; false otherwise
    public func selectCamera(type: CameraDevice) -> Outcome {
        if let device = DeviceCaptureManager.physicalCameraDevice(type) {
            self.activeCaptureDevice = device
            return .success
        }
        
        return .failure
    }
    
    public func minIsoForActiveDevice() -> Float {
        let minIso = self.activeCaptureDevice.activeFormat.minISO
        return minIso
    }
    
    public func maxIsoForActiveDevice() -> Float {
        let maxIso = self.activeCaptureDevice.activeFormat.maxISO
        return maxIso
    }
    
    public func maxExposureSecondsForActiveDevice() -> Float64 {
        let maxDuration = self.activeCaptureDevice.activeFormat.maxExposureDuration
        return CMTimeGetSeconds(maxDuration)
    }
    
    public func minExposureSecondsForActiveDevice() -> Float64 {
        let minDuration = self.activeCaptureDevice.activeFormat.minExposureDuration
        return CMTimeGetSeconds(minDuration)
    }
    
    public func setIsoForActiveDevice(iso : Float, completion: @escaping (CMTime) -> Void) throws {
        
        let minIso = self.minIsoForActiveDevice()
        let maxIso = self.maxIsoForActiveDevice()
        
        let inBounds = (iso >= minIso && iso <= maxIso)
        
        if (!inBounds) {
            throw CaptureManagerError.setIsoFailed
        }
        
        try self.activeCaptureDevice.lockForConfiguration()
        self.activeCaptureDevice.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration, iso: iso, completionHandler: completion)
        self.activeCaptureDevice.unlockForConfiguration()
    }
    
    public func setExposurePointOfInterest(_ point:CGPoint) -> Outcome {
        do {
            try self.activeCaptureDevice.lockForConfiguration()
        }
        catch {
            return .failure
        }
        if let layer = self.videoPreviewLayer {
            let cPoint = layer.captureDevicePointConverted(fromLayerPoint: point)
            self.activeCaptureDevice.exposurePointOfInterest = cPoint
            self.activeCaptureDevice.exposureMode = .continuousAutoExposure
            self.activeCaptureDevice.unlockForConfiguration()
            return .success
        } else {
            return .failure
        }
    }
    
    public func setFocusPointOfInterest(_ point:CGPoint) -> Outcome {
        do {
            try self.activeCaptureDevice.lockForConfiguration()
        }
        catch {
            return .failure
        }
        if let layer = self.videoPreviewLayer {
            let cPoint = layer.captureDevicePointConverted(fromLayerPoint: point)
            self.activeCaptureDevice.focusPointOfInterest = cPoint
            self.activeCaptureDevice.focusMode = .continuousAutoFocus
            self.activeCaptureDevice.unlockForConfiguration()
            return .success
        } else {
            return .failure
        }
    }
    
    public func setExposure(seconds : Float64, completion: @escaping (CMTime) -> Void) throws {
        
        let minExposure = self.minExposureSecondsForActiveDevice()
        let maxExposure = self.maxExposureSecondsForActiveDevice()
        
        let currentTimescale = self.activeCaptureDevice.exposureDuration.timescale
        let inBounds = (seconds >= minExposure && seconds <= maxExposure)
        
        if (!inBounds) {
            throw CaptureManagerError.setExposureFailed
        }
        
        try self.activeCaptureDevice.lockForConfiguration()
        
        self.activeCaptureDevice.setExposureModeCustom(duration: CMTimeMakeWithSeconds(seconds, preferredTimescale: currentTimescale), iso: AVCaptureDevice.currentISO, completionHandler: completion)
        self.activeCaptureDevice.unlockForConfiguration()
    }
    
    // MARK: TODO: Watch for changes to device format and publish this value
    public func currentOutputAspectRatio() -> CGFloat? {
        return CaptureUtils.aspectRatio(for: activeCaptureDevice.activeFormat)
    }
    
    private class func photoSettings(for photoOutput:AVCapturePhotoOutput) -> AVCapturePhotoSettings {
        let settings: AVCapturePhotoSettings = photoOutput.availablePhotoCodecTypes.contains(.hevc) ?
            AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.hevc]) :
            AVCapturePhotoSettings()
        
        photoOutput.maxPhotoQualityPrioritization = .quality // MARK: TODO: Tests to make sure this has been set before setting settings.photoQualityPrioritization
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
            if let device = physicalCameraDevice(preferredDevice) {
                return device
            }
        }
        
        for supportedDevice in supportedCameraDevices {
            if let device = DeviceCaptureManager.physicalCameraDevice(supportedDevice) {
                return device
            }
        }
        
        return nil
    }
    
    private class func physicalCameraDevice(_ device: CameraDevice) -> AVCaptureDevice? {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [device.type], mediaType: .video, position: device.position)
        if let device = session.devices.first {
            return device
        }
        
        return nil
    }
}

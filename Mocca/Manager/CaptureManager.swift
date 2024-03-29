//
//  DeviceCaptureManager.swift
//
//  Created by David Fearon on 15/07/2019.
//  Copyright © 2019 n/a. All rights reserved.
//

import Foundation

enum CaptureDeviceType {
    case builtInWideAngleCamera
    case builtInUltraWideCamera
    case builtInTelephotoCamera
    case builtInDualCamera
    case builtInDualWideCamera
    case builtInTripleCamera
    case unsupported
}

enum CaptureDevicePosition {
    case front
    case back
    case unspecified
    case unsupported
}

struct LogicalCameraDevice: Equatable {
    let type: CaptureDeviceType
    let position: CaptureDevicePosition
}

enum PhotoTakerState: Equatable {
    case ready
    case capturePending
    case saving
    case error(_ error: PhotoTakerError)
}

enum PhotoTakerError: Error {
    case captureError
    case saveError
    case unknown
}

protocol PhotoTakerContract {
    var state: PhotoTakerState { get }
    var statePublisher: Published<PhotoTakerState>.Publisher { get }
    func resetState() -> Result<PhotoTakerState, PhotoTakerError>
    func takePhoto()
}

/// A class to handle creation and management of fully configured video and photo capture sessions and related functions.
class CaptureManager: CaptureManagerContract, ObservableObject {
 
    @Published fileprivate(set) var state: PhotoTakerState = .ready
    var statePublisher: Published<PhotoTakerState>.Publisher { $state }
    
    let videoPreviewLayer: CaptureVideoPreviewLayer
    
    private(set) var captureSession : CaptureSession
    private(set) var activeCaptureDevice : CaptureDevice

    private let photoOutput: CapturePhotoOutput
    private let videoOutput: CaptureVideoOutput
    private let resources: DeviceResourcesContract
    private let photoLibrary: PhotoLibrary
    
    lazy private var photoCaptureIntermediary: PhotoCaptureIntermediary = PhotoCaptureIntermediary(delegate: self)
    
    init(captureSession: CaptureSession, photoOutput: CapturePhotoOutput, videoOutput: CaptureVideoOutput, initialCaptureDevice: CaptureDevice, videoInput: CaptureDeviceInput, resources: DeviceResourcesContract, videoPreviewLayer: CaptureVideoPreviewLayer, photoLibrary: PhotoLibrary) throws {
        
        self.photoOutput = photoOutput
        self.videoOutput = videoOutput
        self.captureSession = captureSession
        self.activeCaptureDevice = initialCaptureDevice
        self.resources = resources
        self.videoPreviewLayer = videoPreviewLayer
        self.photoLibrary = photoLibrary
        
        // MARK: Capture-session configuration
        self.captureSession.beginConfiguration()
        
        // MARK: Capture-session inputs
        if self.captureSession.canAddInput(videoInput) {
            self.captureSession.addInput(videoInput)
        } else {
            throw CaptureManagerError.addVideoInputFailed
        }
        
        // MARK: Capture-sessions outputs
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            throw CaptureManagerError.addPhotoOutputFailed
        }
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            throw CaptureManagerError.addVideoDataOutputFailed
        }
        
        captureSession.commitConfiguration()
    }
    
    /// Starts the capture session
    func startCaptureSession () {
        self.captureSession.startRunning()
    }
    
    /// Stops the capture session
    func stopCaptureSession () {
        self.captureSession.stopRunning()
    }
    
    /// - Returns: A unique copy of current photo settings, without orientation compensation
    private func currentPhotoSettings() -> CapturePhotoSettings {
        return ConfigurationFactory.uniquePhotoSettings(device: self.activeCaptureDevice, photoOutput: self.photoOutput)
    }
    
    /// Sets the active session's capture device to the physical camera matching the supplied type
    /// - Parameter type: The type of camera to select
    /// - Returns: true if the operation succeeded; false otherwise
    func selectCamera(type: LogicalCameraDevice) -> Result<Void, CaptureManagerError> {
        if let device = self.resources.physicalDevice(from: type) {
            self.activeCaptureDevice = device
            return .success
        }
        
        return .failure(.captureDeviceNotFound)
    }
    
    func setSampleBufferDelegate(_ delegate: CaptureVideoDataOutputSampleBufferDelegate,
                                 queue callbackQueue: DispatchQueue) {
        self.videoOutput.setSampleBufferDelegate(delegate, queue: callbackQueue)
    }
}

extension CaptureManager: PhotoCaptureIntermediaryDelegate {
    func didFinishProcessingPhoto(_ photo: CapturePhoto, error: Error?) {
        
        precondition(self.state == .capturePending)
        
        // We continue to attempt the save even if an error is returned, since the API contract guarantees |photo|
        // to be non-nil, and we must never throw away a user's photo if there's still a chance the save might succeed
        
        self.photoLibrary.addPhoto(photo) { success, error in
            self.state = ( success ? .ready : .error(.saveError) )
        }
    }
}

extension CaptureManager: PhotoTakerContract {
    
    func resetState() -> Result<PhotoTakerState, PhotoTakerError> {
        self.state = .ready
        return .success(.ready)
    }
    
    /// Instructs the photo taker to capture a photo.
    func takePhoto() {
        
        self.state = .capturePending
        
        if let photoOutputConnection = self.photoOutput.connection() {
            photoOutputConnection.orientation = Orientation.currentInterfaceOrientation()
        }
        
        self.photoOutput.capture(with: currentPhotoSettings(), delegate: self.photoCaptureIntermediary)
    }
}

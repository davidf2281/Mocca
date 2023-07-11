//
//  DeviceSessionManager.swift
//
//  Created by David Fearon on 15/07/2019.
//  Copyright © 2019 n/a. All rights reserved.
//

import Foundation

enum SessionManagerError: Error {
    case captureDeviceNotFound
    case addVideoInputFailed
    case addVideoDataOutputFailed
    case addPhotoOutputFailed
    case findFullRangeVideoFormatFailed
    case setIsoFailed
    case setExposureFailed
    case setExposureTargetBiasFailed
    case unknown
}

enum SessionManagerConfigError: Error {
    case captureDeviceNotFound
    case videoPreviewLayerNil
}

protocol SessionManagerContract {
    var activeCaptureDevice: CaptureDevice { get }
    var activeCamera: PhysicalCamera { get }
    // Session manager requires a reference to the video preview layer to convert view coords to camera-device coords using
    // AVCaptureVideoPreviewLayer's point-conversion functions. Only the preview layer can do this.
    var videoPreviewLayer: CaptureVideoPreviewLayer { get }
    var captureSession : CaptureSession { get }
    var photoOutput: CapturePhotoOutput { get }
    func startCaptureSession()
    func stopCaptureSession()
    func selectCamera(cameraID: UUID) -> Result<PhysicalCamera, SessionManagerError>
}

/// A class to handle creation and management of fully configured video and photo capture sessions and related functions.
class SessionManager: SessionManagerContract, ObservableObject {

    let videoPreviewLayer: CaptureVideoPreviewLayer
    
    private(set) var captureSession : CaptureSession
    private(set) var activeCaptureDevice : CaptureDevice
    private(set) var activeCamera: PhysicalCamera
    private(set) var photoOutput: CapturePhotoOutput

    private var activeVideoInput: CaptureDeviceInput
    private let videoOutput: CaptureVideoOutput
    private let resources: DeviceResourcesContract
    private let configurationFactory: ConfigurationFactoryContract
    
    init(captureSession: CaptureSession,
         photoOutput: CapturePhotoOutput,
         videoOutput: CaptureVideoOutput,
         initialCamera: PhysicalCamera,
         videoInput: CaptureDeviceInput,
         resources: DeviceResourcesContract,
         videoPreviewLayer: CaptureVideoPreviewLayer,
         configurationFactory: ConfigurationFactoryContract,
         sampleBufferDelegate: CaptureVideoDataOutputSampleBufferDelegate,
         sampleBufferQueue: DispatchQueue) throws {
        
        self.photoOutput = photoOutput
        self.videoOutput = videoOutput
        self.videoOutput.setSampleBufferDelegate(sampleBufferDelegate, queue: sampleBufferQueue)
        self.activeVideoInput = videoInput
        self.captureSession = captureSession
        self.activeCaptureDevice = initialCamera.captureDevice
        self.resources = resources
        self.videoPreviewLayer = videoPreviewLayer
        self.configurationFactory = configurationFactory
        self.activeCamera = initialCamera
        
        // MARK: Capture-session configuration
        self.captureSession.beginConfiguration()
        
        // MARK: Capture-session inputs
        if self.captureSession.canAddInput(videoInput) {
            self.captureSession.addInput(videoInput)
        } else {
            throw SessionManagerError.addVideoInputFailed
        }
        
        // MARK: Capture-sessions outputs
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            throw SessionManagerError.addPhotoOutputFailed
        }
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            throw SessionManagerError.addVideoDataOutputFailed
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
    
    func selectCamera(cameraID: UUID) -> Result<PhysicalCamera, SessionManagerError> {
   
        guard let physicalCamera = self.resources.availablePhysicalCameras.first(where: { $0.id == cameraID}) else {
            return .failure(.captureDeviceNotFound)
        }
        
        do {
            let videoInput = try self.configurationFactory.videoInput(for: physicalCamera.captureDevice)
            self.captureSession.removeInput(self.activeVideoInput)
            if self.captureSession.canAddInput(videoInput) {
                self.captureSession.addInput(videoInput)
                self.activeVideoInput = videoInput
            } else {
                return .failure(.addVideoInputFailed)
            }
        } catch {
            return .failure(.addVideoInputFailed)
        }
        
        self.activeCaptureDevice = physicalCamera.captureDevice
        self.activeCamera = physicalCamera
        return .success(physicalCamera)
    }
}

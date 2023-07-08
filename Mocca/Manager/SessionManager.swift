//
//  DeviceSessionManager.swift
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

protocol Camera {
    var type: CaptureDeviceType { get }
    var position: CaptureDevicePosition { get }
}

struct LogicalCamera: Camera, Equatable {
    let type: CaptureDeviceType
    let position: CaptureDevicePosition
}

struct PhysicalCamera: Camera, Identifiable {
    let id: UUID
    let type: CaptureDeviceType
    let position: CaptureDevicePosition
    let captureDevice: CaptureDevice
}

extension PhysicalCamera: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

/// A class to handle creation and management of fully configured video and photo capture sessions and related functions.
class SessionManager: SessionManagerContract, ObservableObject {
    
    @Published fileprivate(set) var state: CaptureManagerState = .ready

    var statePublisher: Published<CaptureManagerState>.Publisher { $state }
    
    let videoPreviewLayer: CaptureVideoPreviewLayer
    
    private(set) var captureSession : CaptureSession
    private(set) var activeCaptureDevice : CaptureDevice
    private(set) var activeCamera: PhysicalCamera

    private var activeVideoInput: CaptureDeviceInput
    private let photoOutput: CapturePhotoOutput
    private let videoOutput: CaptureVideoOutput
    private let resources: DeviceResourcesContract
    private let photoLibrary: PhotoLibrary
    private let configurationFactory: ConfigurationFactoryContract
    
    lazy private var photoCaptureIntermediary: PhotoCaptureIntermediary = PhotoCaptureIntermediary(delegate: self)
    
    init(captureSession: CaptureSession, photoOutput: CapturePhotoOutput, videoOutput: CaptureVideoOutput, initialCamera: PhysicalCamera, videoInput: CaptureDeviceInput, resources: DeviceResourcesContract, videoPreviewLayer: CaptureVideoPreviewLayer, photoLibrary: PhotoLibrary, configurationFactory: ConfigurationFactoryContract, sampleBufferDelegate: CaptureVideoDataOutputSampleBufferDelegate, sampleBufferQueue: DispatchQueue) throws {
        
        self.photoOutput = photoOutput
        self.videoOutput = videoOutput
        self.videoOutput.setSampleBufferDelegate(sampleBufferDelegate, queue: sampleBufferQueue)
        self.activeVideoInput = videoInput
        self.captureSession = captureSession
        self.activeCaptureDevice = initialCamera.captureDevice
        self.resources = resources
        self.videoPreviewLayer = videoPreviewLayer
        self.photoLibrary = photoLibrary
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
    
    /// - Returns: A unique copy of current photo settings, without orientation compensation
    private func currentPhotoSettings() -> CapturePhotoSettings {
        return self.configurationFactory.uniquePhotoSettings(device: self.activeCaptureDevice, photoOutput: self.photoOutput)
    }
    
    func selectCamera(cameraID: UUID) -> Result<Void, SessionManagerError> {
   
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
        return .success
    }
}

extension SessionManager: PhotoCaptureIntermediaryDelegate {
    func didFinishProcessingPhoto(_ photo: CapturePhoto, error: Error?) {
        
        precondition(self.state == .capturePending)
        
        // We continue to attempt the save even if an error is returned, since the API contract guarantees |photo|
        // to be non-nil, and we must never throw away a user's photo if there's still a chance the save might succeed
        
        self.photoLibrary.addPhoto(photo) { success, error in
            self.state = ( success ? .ready : .error(.saveError) )
        }
    }
}

extension SessionManager: CaptureManagerContract {
    
    func resetState() -> Result<CaptureManagerState, CaptureManagerError> {
        self.state = .ready
        return .success(.ready)
    }
    
    /// Instructs the photo taker to capture a photo.
    func capturePhoto() {
        
        self.state = .capturePending
        
        if let photoOutputConnection = self.photoOutput.connection() {
            photoOutputConnection.orientation = Orientation.currentInterfaceOrientation()
        }
        
        self.photoOutput.capture(with: currentPhotoSettings(), delegate: self.photoCaptureIntermediary)
    }
}

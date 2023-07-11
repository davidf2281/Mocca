//
//  MockSessionManager.swift
//  MoccaTests
//
//  Created by David Fearon on 05/10/2020.
//

import Foundation
import AVFoundation

@testable import Mocca
class MockSessionManager: SessionManagerContract {
   
    var activeCamera: PhysicalCamera = PhysicalCamera(id: UUID(), type: .builtInTelephotoCamera, position: .back, captureDevice: MockCaptureDevice())
    
    // Protocol conformance
    let activeCaptureDevice: CaptureDevice
    let videoPreviewLayer: CaptureVideoPreviewLayer
    let captureSession : CaptureSession
    
    func capturePhoto(settings: CapturePhotoSettings, delegate: CapturePhotoDelegate) {
        self.capturePhotoCalled = true
        self.captureDelegate = delegate
    }
    
    init(captureDevice: CaptureDevice = MockCaptureDevice(), layer: CaptureVideoPreviewLayer = MockCaptureVideoPreviewLayer(), captureSession: CaptureSession = MockCaptureSession()) {
        self.activeCaptureDevice = captureDevice
        self.videoPreviewLayer = layer
        self.captureSession = captureSession
    }
    
    func startCaptureSession(){}
    func stopCaptureSession() {}
    func currentPhotoSettings() -> CapturePhotoSettings {
        return AVCapturePhotoSettings()
    }
    
    func selectCamera(type: LogicalCamera) -> Result<Void, SessionManagerError> {
        lastSelectedCameraDevice = type
        return .success
    }
    
    var selectedCameraID: UUID?
    var selectCameraCallCount = 0
    var selectedCameraToReturn: PhysicalCamera!
    func selectCamera(cameraID: UUID) -> Result<PhysicalCamera, SessionManagerError> {
        selectedCameraID = cameraID
        selectCameraCallCount += 1
        return .success(selectedCameraToReturn)
    }
    
    var photoOutputToReturn: CapturePhotoOutput = MockCapturePhotoOutput()
    var photoOutput: CapturePhotoOutput {
        return photoOutputToReturn
    }
    
    // Test vars
    var capturePhotoCalled = false;
    var captureDelegate: CapturePhotoDelegate?
    var lastSelectedCameraDevice: LogicalCamera?
}

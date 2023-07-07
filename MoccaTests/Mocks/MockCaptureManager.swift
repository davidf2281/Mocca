//
//  MockCaptureManager.swift
//  MoccaTests
//
//  Created by David Fearon on 05/10/2020.
//

import Foundation
import AVFoundation

@testable import Mocca
class MockCaptureManager: CaptureManagerContract {
    
    var activeCamera: PhysicalCamera {
        return PhysicalCamera(id: UUID(), type: .builtInTelephotoCamera, position: .back, captureDevice: MockCaptureDevice())
    }
    
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
    
    func selectCamera(type: LogicalCamera) -> Result<Void, CaptureManagerError> {
        lastSelectedCameraDevice = type
        return .success
    }
    
    var selectedCameraID: UUID?
    var selectCameraCallCOunt = 0
    func selectCamera(cameraID: UUID) -> Result<Void, CaptureManagerError> {
        selectedCameraID = cameraID
        selectCameraCallCOunt += 1
        return .success
    }
    
    func setSampleBufferDelegate(_ delegate: CaptureVideoDataOutputSampleBufferDelegate, queue callbackQueue: DispatchQueue) {}
    
    // Test vars
    var capturePhotoCalled = false;
    var captureDelegate: CapturePhotoDelegate?
    var lastSelectedCameraDevice: LogicalCamera?
}

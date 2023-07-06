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
    
    func selectCamera(type: LogicalCameraDevice) -> Result<Void, CaptureManagerError> {
        lastSelectedCameraDevice = type
        return .success
    }
    
    func setSampleBufferDelegate(_ delegate: CaptureVideoDataOutputSampleBufferDelegate, queue callbackQueue: DispatchQueue) {}
    
    // Test vars
    var capturePhotoCalled = false;
    var captureDelegate: CapturePhotoDelegate?
    var lastSelectedCameraDevice: LogicalCameraDevice?
}

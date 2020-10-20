//
//  MockCaptureManager.swift
//  MoccaTests
//
//  Created by David Fearon on 05/10/2020.
//

import Foundation
@testable import Mocca
class MockCaptureManager: CaptureManager {
    
    // Protocol conformance
    var activeCaptureDevice: TestableAVCaptureDevice
    var videoPreviewLayer: TestableAVCaptureVideoPreviewLayer?
    
    func capturePhoto(settings: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate) {
        self.capturePhotoCalled = true
        self.captureDelegate = delegate
    }
    
    init() {
        activeCaptureDevice = MockAVCaptureDevice()
        videoPreviewLayer = MockAVCaptureVideoPreviewLayer()
    }
    
    init(captureDevice:TestableAVCaptureDevice, layer: TestableAVCaptureVideoPreviewLayer) {
        activeCaptureDevice = captureDevice
        videoPreviewLayer = layer
    }
    
    func startCaptureSession(){}
    func stopCaptureSession() {}
    func currentPhotoSettings() -> AVCapturePhotoSettings {
        return AVCapturePhotoSettings()
    }
    
    // Test vars
    var capturePhotoCalled = false;
    var captureDelegate: AVCapturePhotoCaptureDelegate?
}

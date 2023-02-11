//
//  MockCaptureManager.swift
//  MoccaTests
//
//  Created by David Fearon on 05/10/2020.
//

import Foundation
@testable import Mocca
class MockCaptureManager: CaptureManagerContract {
    
    // Protocol conformance
    var activeCaptureDevice: AVCaptureDeviceContract
    var videoPreviewLayer: AVCaptureVideoPreviewLayerContract?
    
    func capturePhoto(settings: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate) {
        self.capturePhotoCalled = true
        self.captureDelegate = delegate
    }
    
    init() {
        activeCaptureDevice = MockAVCaptureDevice()
        videoPreviewLayer = MockAVCaptureVideoPreviewLayer()
    }
    
    init(captureDevice:AVCaptureDeviceContract, layer: AVCaptureVideoPreviewLayerContract) {
        activeCaptureDevice = captureDevice
        videoPreviewLayer = layer
    }
    
    func startCaptureSession(){}
    func stopCaptureSession() {}
    func currentPhotoSettings() -> AVCapturePhotoSettings {
        return AVCapturePhotoSettings()
    }
    
    func selectCamera(type: LogicalCameraDevice) -> Result<Void, CaptureManagerError> {
        lastSelectedCameraDevice = type
        return .success
    }
    
    func setSampleBufferDelegate(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue callbackQueue: DispatchQueue) {}
    
    // Test vars
    var capturePhotoCalled = false;
    var captureDelegate: AVCapturePhotoCaptureDelegate?
    var lastSelectedCameraDevice: LogicalCameraDevice?
}

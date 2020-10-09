//
//  MockCaptureManager.swift
//  MoccaTests
//
//  Created by David Fearon on 05/10/2020.
//

import Foundation
@testable import Mocca
class MockCaptureManager: CaptureManager {
    // Test vars
    var capturePhotoCalled = false;
    var captureDelegate: AVCapturePhotoCaptureDelegate?
    var exposurePointOfInterestCalled = false
    var focusPointOfInterestCalled = false
    var focusSetPoint = CGPoint.zero
    var exposureSetPoint = CGPoint.zero
    var dragEndedFrameSize = CGSize.zero
    
    func capturePhoto(delegate: AVCapturePhotoCaptureDelegate) {
        self.capturePhotoCalled = true
        self.captureDelegate = delegate
    }
    
    func setExposurePointOfInterest(_ point: CGPoint) -> Outcome {
        self.exposurePointOfInterestCalled = true
        self.exposureSetPoint = point
        return .success
    }
    
    func setFocusPointOfInterest(_ point:CGPoint) -> Outcome {
        self.focusPointOfInterestCalled = true
        self.focusSetPoint = point
        return .success
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: TestableAVCaptureSession = MockAVCaptureSession()
    var activeCaptureDevice: TestableAVCaptureDevice = MockAVCaptureDevice()
    var isExposurePointOfInterestSupported: Bool = true
    func currentPhotoSettings() -> AVCapturePhotoSettings { return AVCapturePhotoSettings()  }
    func startCaptureSession() {}
    func stopCaptureSession() {}
    func selectUltraWideCamera() {}
    func selectWideCamera() {}
    func selectTelephotoCamera() {}
    func minIsoForActiveDevice() -> Float { return 0 }
    func maxIsoForActiveDevice() -> Float { return 0 }
    func maxExposureSecondsForActiveDevice() -> Float64 { return 0 }
    func minExposureSecondsForActiveDevice() -> Float64 { return 0 }
    func setIsoForActiveDevice(iso: Float, completion: @escaping (CMTime) -> Void) throws {}
 
    func setExposure(seconds: Float64, completion: @escaping (CMTime) -> Void) throws {}
    func currentOutputAspectRatio() -> CGFloat? { return 0 }
}

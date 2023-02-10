//
//  MockCameraOperation.swift
//  MoccaTests
//
//  Created by David Fearon on 09/02/2023.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockCameraOperation: CameraOperationContract {
    
    var setIsoCalls = 0
    func setIso(_ iso: Float, for device: Mocca.AVCaptureDeviceContract, utils: Mocca.CaptureUtilsContract, completion: @escaping (CMTime) -> Void) throws {
        setIsoCalls += 1
    }
    
    var setExposureCalls = 0
    func setExposure(seconds: Float64, for device: Mocca.AVCaptureDeviceContract, utils: Mocca.CaptureUtilsContract, completion: @escaping (CMTime) -> Void) throws {
        setExposureCalls += 0
    }
    
    var canSetExposureTargetBiasCalls = 0
    func canSetExposureTargetBias(ev: Mocca.EV, for device: Mocca.AVCaptureDeviceContract) -> Bool {
        canSetExposureTargetBiasCalls += 1
        return true
    }
    
    var setExposureTargetBiasCalls = 0
    func setExposureTargetBias(ev: Mocca.EV, for device: Mocca.AVCaptureDeviceContract, completion: @escaping (CMTime) -> Void) throws {
        setExposureTargetBiasCalls += 1
    }
    
    var setExposurePointOfInterestCalls = 0
    func setExposurePointOfInterest(_ point: CGPoint, on layer: Mocca.AVCaptureVideoPreviewLayerContract, for device: inout Mocca.AVCaptureDeviceContract) -> Result<Void, Mocca.CameraOperation.OperationError> {
        setExposurePointOfInterestCalls += 1
        return .success
    }
    
    var setFocusPointOfInterestCalls = 0
    func setFocusPointOfInterest(_ point: CGPoint, on layer: Mocca.AVCaptureVideoPreviewLayerContract, for device: inout Mocca.AVCaptureDeviceContract) -> Result<Void, Mocca.CameraOperation.OperationError> {
        setFocusPointOfInterestCalls += 1
        return .success
    }
    
    var willTargetBiasHaveEffectCalls = 0
    func willTargetBiasHaveEffect(ev: Mocca.EV, for device: Mocca.AVCaptureDeviceContract) -> Bool {
        willTargetBiasHaveEffectCalls += 1
        return true
    }
}

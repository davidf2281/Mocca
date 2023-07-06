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
    func setIso(_ iso: Float, for device: CaptureDevice, utils: CaptureUtilsContract, completion: @escaping (CMTime) -> Void) throws {
        setIsoCalls += 1
    }
    
    var setExposureCalls = 0
    func setExposure(seconds: Float64, for device: CaptureDevice, utils: CaptureUtilsContract, completion: @escaping (CMTime) -> Void) throws {
        setExposureCalls += 0
    }
    
    var canSetExposureTargetBiasCalls = 0
    var canSetExposureTargetBiasValueToReturn = true
    func canSetExposureTargetBias(ev: EV, for device: CaptureDevice) -> Bool {
        canSetExposureTargetBiasCalls += 1
        return canSetExposureTargetBiasValueToReturn
    }
    
    var setExposureTargetBiasCalls = 0
    var setExposureTargetBiasShouldThrow = false
    func setExposureTargetBias(ev: EV, for device: CaptureDevice, completion: ((CMTime) -> Void)?) throws {
        setExposureTargetBiasCalls += 1
        if setExposureTargetBiasShouldThrow {
            throw MockCameraOperationError.setExposureTargetBias
        }
    }
    
    var setExposurePointOfInterestCalls = 0
    func setExposurePointOfInterest(_ point: CGPoint, on layer: CaptureVideoPreviewLayer, for device: CaptureDevice) -> Result<Void, CameraOperation.OperationError> {
        setExposurePointOfInterestCalls += 1
        return .success
    }
    
    var setFocusPointOfInterestCalls = 0
    func setFocusPointOfInterest(_ point: CGPoint, on layer: CaptureVideoPreviewLayer, for device: CaptureDevice) -> Result<Void, CameraOperation.OperationError> {
        setFocusPointOfInterestCalls += 1
        return .success
    }
    
    var willTargetBiasHaveEffectCalls = 0
    func willTargetBiasHaveEffect(ev: EV, for device: CaptureDevice) -> Bool {
        willTargetBiasHaveEffectCalls += 1
        return true
    }
}

enum MockCameraOperationError: Error {
    case setExposureTargetBias
}

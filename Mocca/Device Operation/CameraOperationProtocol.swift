//
//  CameraOperationProtocol.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

protocol CameraOperationProtocol {
    
    static func setIso(_ iso : Float, for device: TestableAVCaptureDevice, utils:CaptureUtils, completion: @escaping (CMTime) -> Void) throws

    static func setExposure(seconds : Float64, for device: TestableAVCaptureDevice, utils:CaptureUtils, completion: @escaping (CMTime) -> Void) throws
    
    static func canSetExposureTargetBias(ev: EV, for device: TestableAVCaptureDevice) -> Bool
    
    static func setExposureTargetBias(ev: EV, for device: TestableAVCaptureDevice, completion: @escaping (CMTime) -> Void) throws
    
    static func setExposurePointOfInterest(_ point:CGPoint,
                                    on layer: TestableAVCaptureVideoPreviewLayer,
                                    for device: inout TestableAVCaptureDevice) -> Outcome
    
    static func setFocusPointOfInterest(_ point:CGPoint,
                                 on layer: TestableAVCaptureVideoPreviewLayer,
                                 for device: inout TestableAVCaptureDevice) -> Outcome

}

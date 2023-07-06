//
//  CameraOperationProtocol.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import CoreMedia.CMTime

protocol CameraOperationContract {
    
    func setIso(_ iso : Float, for device: CaptureDevice, utils:CaptureUtilsContract, completion: @escaping (CMTime) -> Void) throws
    func setExposure(seconds : Float64, for device: CaptureDevice, utils:CaptureUtilsContract, completion: @escaping (CMTime) -> Void) throws
    func canSetExposureTargetBias(ev: EV, for device: CaptureDevice) -> Bool
    func setExposureTargetBias(ev: EV, for device: CaptureDevice, completion: ( (CMTime) -> Void)?) throws
    func setExposurePointOfInterest(_ point:CGPoint,
                                    on layer: CaptureVideoPreviewLayer,
                                           for device: CaptureDevice) -> Result<Void, CameraOperation.OperationError>
     func setFocusPointOfInterest(_ point:CGPoint,
                                 on layer: CaptureVideoPreviewLayer,
                                 for device: CaptureDevice) -> Result<Void, CameraOperation.OperationError>
    func willTargetBiasHaveEffect(ev: EV, for device: CaptureDevice) -> Bool
}

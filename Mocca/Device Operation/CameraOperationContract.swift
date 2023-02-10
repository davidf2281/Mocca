//
//  CameraOperationProtocol.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

protocol CameraOperationContract {
    
    func setIso(_ iso : Float, for device: AVCaptureDeviceContract, utils:CaptureUtilsContract, completion: @escaping (CMTime) -> Void) throws

    func setExposure(seconds : Float64, for device: AVCaptureDeviceContract, utils:CaptureUtilsContract, completion: @escaping (CMTime) -> Void) throws
    
    func canSetExposureTargetBias(ev: EV, for device: AVCaptureDeviceContract) -> Bool
    
    func setExposureTargetBias(ev: EV, for device: AVCaptureDeviceContract, completion: @escaping (CMTime) -> Void) throws
    
    func setExposurePointOfInterest(_ point:CGPoint,
                                    on layer: AVCaptureVideoPreviewLayerContract,
                                           for device: inout AVCaptureDeviceContract) -> Result<Void, CameraOperation.OperationError>
    
     func setFocusPointOfInterest(_ point:CGPoint,
                                 on layer: AVCaptureVideoPreviewLayerContract,
                                 for device: inout AVCaptureDeviceContract) -> Result<Void, CameraOperation.OperationError>
    
    func willTargetBiasHaveEffect(ev: EV, for device: AVCaptureDeviceContract) -> Bool

}

//
//  CameraOperation.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

class CameraOperation: CameraOperationProtocol {    
    
    public static func setIso(_ iso : Float, for device: AVCaptureDevice, completion: @escaping (CMTime) -> Void) throws {
        
        let minIso = CaptureUtils.minIso(for: device)
        let maxIso = CaptureUtils.maxIso(for: device)
        
        let inBounds = (iso >= minIso && iso <= maxIso)
        
        if (!inBounds) {
            throw CaptureManagerError.setIsoFailed
        }
        
        try device.lockForConfiguration()
        device.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration, iso: iso, completionHandler: completion)
        device.unlockForConfiguration()
    }
    
    public static func setExposurePointOfInterest(_ point:CGPoint, on layer: TestableAVCaptureVideoPreviewLayer, for device: inout TestableAVCaptureDevice) -> Outcome {
        
        do {
            try device.lockForConfiguration()
        }
        catch {
            return .failure
        }
        
        let convertedPoint = layer.captureDevicePointConverted(fromLayerPoint: point)
        device.exposurePointOfInterest = convertedPoint
        device.exposureMode = .continuousAutoExposure
        device.unlockForConfiguration()
        return .success
    }
    
    public static func setFocusPointOfInterest(_ point:CGPoint, on layer: TestableAVCaptureVideoPreviewLayer, for device: inout TestableAVCaptureDevice) -> Outcome {
        
        do {
            try device.lockForConfiguration()
        }
        catch {
            return .failure
        }
        
        let convertedPoint = layer.captureDevicePointConverted(fromLayerPoint: point)
        device.focusPointOfInterest = convertedPoint
        device.focusMode = .continuousAutoFocus
        device.unlockForConfiguration()
        return .success
    }
    
    public static func setExposure(seconds : Float64, for device: AVCaptureDevice, completion: @escaping (CMTime) -> Void) throws {
        
        let minExposure = CaptureUtils.minExposureSeconds(for: device)
        let maxExposure = CaptureUtils.maxExposureSeconds(for: device)
        
        let currentTimescale = device.exposureDuration.timescale
        let inBounds = (seconds >= minExposure && seconds <= maxExposure)
        
        if (!inBounds) {
            throw CaptureManagerError.setExposureFailed
        }
        
        try device.lockForConfiguration()
        
        device.setExposureModeCustom(duration: CMTimeMakeWithSeconds(seconds, preferredTimescale: currentTimescale), iso: AVCaptureDevice.currentISO, completionHandler: completion)
        device.unlockForConfiguration()
    }
    
}

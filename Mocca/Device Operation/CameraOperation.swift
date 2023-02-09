//
//  CameraOperation.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

class CameraOperation: CameraOperationContract {
    
    public func setIso(_ iso : Float, for device: AVCaptureDeviceContract, utils:CaptureUtils, completion: @escaping (CMTime) -> Void) throws {
        
        let minIso = utils.minIso(for: device)
        let maxIso = utils.maxIso(for: device)
        
        let inBounds = (iso >= minIso && iso <= maxIso)
        
        if (!inBounds) {
            throw CaptureManagerError.setIsoFailed
        }
        
        try device.lockForConfiguration()
        device.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration, iso: iso, completionHandler: completion)
        device.unlockForConfiguration()
    }
    
    public func setExposure(seconds : Float64, for device: AVCaptureDeviceContract, utils:CaptureUtils, completion: @escaping (CMTime) -> Void) throws {
        
        let minExposure = utils.minExposureSeconds(for: device)
        let maxExposure = utils.maxExposureSeconds(for: device)
        
        let currentTimescale = device.exposureDuration.timescale
        let inBounds = (seconds >= minExposure && seconds <= maxExposure)
        
        if (!inBounds) {
            throw CaptureManagerError.setExposureFailed
        }
        
        try device.lockForConfiguration()
        device.setExposureModeCustom(duration: CMTimeMakeWithSeconds(seconds, preferredTimescale: currentTimescale), iso: AVCaptureDevice.currentISO, completionHandler: completion)
        device.unlockForConfiguration()
    }
    
    func canSetExposureTargetBias(ev: EV, for device: AVCaptureDeviceContract) -> Bool {
        let minBias = device.minExposureTargetBias
        let maxBias = device.maxExposureTargetBias
        
        return ev >= minBias && ev <= maxBias
    }
    
    func willTargetBiasHaveEffect(ev: EV, for device: AVCaptureDeviceContract) -> Bool {
        let isoIsOnUpperLimit = device.iso >= device.activeFormat.maxISO

        let isoIsOnLowerLimit = device.iso <= device.activeFormat.minISO
        
        if isoIsOnUpperLimit && ev >= device.exposureTargetBias {
            return false
        }
        
        if isoIsOnLowerLimit && ev <= device.exposureTargetBias {
            return false
        }
        
        return true
    }
    
    func setExposureTargetBias(ev: EV, for device: AVCaptureDeviceContract, completion: @escaping (CMTime) -> Void) throws {

        let minBias = device.minExposureTargetBias
        let maxBias = device.maxExposureTargetBias
        
        let inBounds = (ev >= minBias && ev <= maxBias)
        
        if (!inBounds) {
            throw CaptureManagerError.setExposureTargetBiasFailed
        }
        
        try device.lockForConfiguration()
        device.setExposureTargetBias(ev, completionHandler: completion)
        device.unlockForConfiguration()
    }
    
    func setExposurePointOfInterest(_ point:CGPoint, on layer: AVCaptureVideoPreviewLayerContract, for device: inout AVCaptureDeviceContract) -> Result<Void, OperationError> {
        
        do {
            try device.lockForConfiguration()
        }
        catch {
            return .failure(.lockForConfigurationFailed)
        }
        
        let convertedPoint = layer.captureDevicePointConverted(fromLayerPoint: point)
        device.exposurePointOfInterest = convertedPoint
        device.exposureMode = .autoExpose
        device.unlockForConfiguration()
        return .success
    }
    
    func setFocusPointOfInterest(_ point:CGPoint, on layer: AVCaptureVideoPreviewLayerContract, for device: inout AVCaptureDeviceContract) -> Result<Void, OperationError> {
        
        do {
            try device.lockForConfiguration()
        }
        catch {
            return .failure(.lockForConfigurationFailed)
        }
        
        let convertedPoint = layer.captureDevicePointConverted(fromLayerPoint: point)
        device.focusPointOfInterest = convertedPoint
        device.focusMode = .autoFocus
        device.unlockForConfiguration()
        return .success
    }
}

extension CameraOperation {
    enum OperationError: Error {
        case lockForConfigurationFailed
    }
}

// https://stackoverflow.com/a/46863180/2201154
extension Result where Success == Void {
    static var success: Result {
        return .success(())
    }
}

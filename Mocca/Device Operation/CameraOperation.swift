//
//  CameraOperation.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

class CameraOperation: CameraOperationContract {
    
    func setIso(_ iso : Float, for device: CaptureDevice, utils: CaptureUtilsContract = CaptureUtils(), completion: @escaping (CMTime) -> Void) throws {
        
        let minIso = utils.minIso(for: device)
        let maxIso = utils.maxIso(for: device)
        
        let inBounds = (iso >= minIso && iso <= maxIso)
        
        if (!inBounds) {
            throw SessionManagerError.setIsoFailed
        }
        
        try device.lockForConfiguration()
        device.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration, iso: iso, completionHandler: completion)
        device.unlockForConfiguration()
    }
    
    func setExposure(seconds : Float64, for device: CaptureDevice, utils: CaptureUtilsContract = CaptureUtils(), completion: @escaping (CMTime) -> Void) throws {
        
        let minExposure = utils.minExposureSeconds(for: device)
        let maxExposure = utils.maxExposureSeconds(for: device)
        
        let currentTimescale = device.exposureDuration.timescale
        let inBounds = (seconds >= minExposure && seconds <= maxExposure)
        
        if (!inBounds) {
            throw SessionManagerError.setExposureFailed
        }
        
        try device.lockForConfiguration()
        device.setExposureModeCustom(duration: CMTimeMakeWithSeconds(seconds, preferredTimescale: currentTimescale), iso: AVCaptureDevice.currentISO, completionHandler: completion)
        device.unlockForConfiguration()
    }
    
    
    func canSetExposureTargetBias(ev: EV, for device: CaptureDevice) -> Bool {
        let minBias = device.minExposureTargetBias
        let maxBias = device.maxExposureTargetBias
        
        return ev >= minBias && ev <= maxBias
    }
    
    func willTargetBiasHaveEffect(ev: EV, for device: CaptureDevice) -> Bool {
        let isoIsOnUpperLimit = device.iso >= device.activeFormat.maxISO

        let isoIsOnLowerLimit = device.iso <= device.activeFormat.minISO
        
        if isoIsOnUpperLimit && ev >= device.maxExposureTargetBias {
            return false
        }
        
        if isoIsOnLowerLimit && ev <= device.minExposureTargetBias {
            return false
        }
        
        return true
    }
    
    func setExposureTargetBias(ev: EV, for device: CaptureDevice, completion: ((CMTime) -> Void)?) throws {

        let minBias = device.minExposureTargetBias
        let maxBias = device.maxExposureTargetBias
        
        let inBounds = (ev >= minBias && ev <= maxBias)
        
        if (!inBounds) {
            throw SessionManagerError.setExposureTargetBiasFailed
        }
        
        try device.lockForConfiguration()
        device.setExposureTargetBias(ev, completionHandler: completion)
        device.unlockForConfiguration()
    }
    
    func setExposurePointOfInterest(_ point:CGPoint, on layer: CaptureVideoPreviewLayer, for device: CaptureDevice) -> Result<Void, OperationError> {
        
        guard device.exposurePointOfInterestSupported else {
            return .failure(.exposurePointOfInterestUnsupported)
        }
        
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
    
    func setFocusPointOfInterest(_ point:CGPoint, on layer: CaptureVideoPreviewLayer, for device: CaptureDevice) -> Result<Void, OperationError> {
        
        guard device.focusPointOfInterestSupported else {
            return .failure(.focusPointOfInterestUnsupported)
        }
        
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
        case focusPointOfInterestUnsupported
        case exposurePointOfInterestUnsupported
    }
}

// Credit: https://stackoverflow.com/a/46863180/2201154
extension Result where Success == Void {
    static var success: Result {
        return .success(())
    }
}

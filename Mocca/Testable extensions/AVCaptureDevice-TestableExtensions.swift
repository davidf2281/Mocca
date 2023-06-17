//
//  AVCaptureDevice-TestableExtensions.swift
//  Mocca
//
//  Created by David Fearon on 12/02/2023.
//

import Foundation
import AVFoundation

protocol AVCaptureDeviceContract: AnyObject {
    var iso: Float { get }
    var activeFormat: AVCaptureDeviceFormatContract { get set }
    var formats: [AVCaptureDeviceFormatContract] { get }
    var activeVideoMinFrameDuration: CMTime { get set }
    var exposureDuration: CMTime { get }
    var exposureTargetBias: Float { get }
    var maxExposureTargetBias: Float { get }
    var minExposureTargetBias: Float { get }
    var isExposurePointOfInterestSupported: Bool { get }
    var exposurePointOfInterest: CGPoint { get set }
    var exposureMode: AVCaptureDevice.ExposureMode { get set }
    var focusPointOfInterest: CGPoint { get set }
    var focusMode: AVCaptureDevice.FocusMode { get set }
    func setFocusModeLocked(lensPosition: Float, completionHandler handler: ((CMTime) -> Void)?)
    func setExposureModeCustom(duration: CMTime, iso ISO: Float, completionHandler handler: ((CMTime) -> Void)?)
    func setExposureTargetBias(_ bias: Float, completionHandler handler: ((CMTime) -> Void)?)
    func lockForConfiguration() throws
    func unlockForConfiguration()
}

protocol AVCaptureDevicePropertyUnshadowing {
    var activeFormat: AVCaptureDevice.Format { get set }
    var formats: [AVCaptureDevice.Format] { get }
}

extension AVCaptureDevice: AVCaptureDeviceContract {}
extension AVCaptureDevice: AVCaptureDevicePropertyUnshadowing {}

private class EmptyAVCaptureDeviceFormat: AVCaptureDeviceFormatContract {}

extension AVCaptureDeviceContract {
    private var realDevice: AVCaptureDevicePropertyUnshadowing? { self as? AVCaptureDevice }

    var activeFormat: AVCaptureDeviceFormatContract {
        get { realDevice?.activeFormat ?? assert(EmptyAVCaptureDeviceFormat()) }
        set {
            if let newValue = newValue as? AVCaptureDevice.Format, var realDevice {
                realDevice.activeFormat = newValue
            }
        }
    }
    
    var formats: [AVCaptureDeviceFormatContract] { realDevice?.formats ?? assert([]) }
}

fileprivate func assert<T>(_ value: T) -> T {
    Swift.assert(false)
    return value
}

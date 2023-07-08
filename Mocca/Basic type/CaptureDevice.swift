//
//  CaptureDevice.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation
import CoreMedia.CMTime
import AVFoundation.AVCaptureDevice

enum CaptureDeviceType {
    case builtInWideAngleCamera
    case builtInUltraWideCamera
    case builtInTelephotoCamera
    case builtInDualCamera
    case builtInDualWideCamera
    case builtInTripleCamera
    case unsupported
}

enum CaptureDevicePosition {
    case front
    case back
    case unspecified
    case unsupported
}

protocol CaptureDevice: AnyObject {
    var iso: Float { get }
    var activeFormat: CaptureDeviceFormat { get set }
    var formats: [CaptureDeviceFormat] { get }
    var activeVideoMinFrameDuration: CMTime { get set }
    var exposureDuration: CMTime { get }
    var exposureTargetBias: Float { get }
    var maxExposureTargetBias: Float { get }
    var minExposureTargetBias: Float { get }
    var isExposurePointOfInterestSupported: Bool { get }
    var exposurePointOfInterestSupported: Bool { get }
    var exposurePointOfInterest: CGPoint { get set }
    var exposureMode: AVCaptureDevice.ExposureMode { get set }
    var focusPointOfInterestSupported: Bool { get }
    var focusPointOfInterest: CGPoint { get set }
    var focusMode: AVCaptureDevice.FocusMode { get set }
    func setFocusModeLocked(lensPosition: Float, completionHandler handler: ((CMTime) -> Void)?)
    func setExposureModeCustom(duration: CMTime, iso ISO: Float, completionHandler handler: ((CMTime) -> Void)?)
    func setExposureTargetBias(_ bias: Float, completionHandler handler: ((CMTime) -> Void)?)
    func lockForConfiguration() throws
    func unlockForConfiguration()
    
    var captureDeviceType: CaptureDeviceType { get }
    var captureDevicePosition: CaptureDevicePosition { get }
    func captureDevice(withType deviceType: CaptureDeviceType, position: CaptureDevicePosition) -> CaptureDevice?
    func availablePhysicalDevices(for logicalCameraDevices: [LogicalCamera]) -> [CaptureDevice]
}

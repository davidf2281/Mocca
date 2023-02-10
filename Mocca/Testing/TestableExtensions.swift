//
//  CaptureManagerExtensions.swift
//  Mocca
//
//  Created by David Fearon on 23/07/2019.
//  Copyright © 2019 --. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

/* Empty extensions are required. */
extension AVCaptureDevice:            AVCaptureDeviceContract {}
extension AVCaptureDeviceInput:       AVCaptureDeviceInputContract {}
extension AVCaptureSession:           AVCaptureSessionContract {}
extension AVCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayerContract {}
extension CMSampleBuffer:             CMSampleBufferContract { }
extension PHPhotoLibrary:             PHPhotoLibraryContract {}

protocol AVCaptureDeviceContract: AnyObject {
    var iso: Float { get }
    var activeFormat: AVCaptureDeviceFormatContract { get set }
    var formats: [AVCaptureDevice.Format] { get }
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

protocol AVCaptureDeviceInputContract {}

protocol CMSampleBufferContract: AnyObject {}

protocol AVCaptureVideoPreviewLayerContract {
    func captureDevicePointConverted(fromLayerPoint pointInLayer: CGPoint) -> CGPoint
}

protocol AVCaptureSessionContract {
    var sessionPreset: AVCaptureSession.Preset { get set }
    func beginConfiguration()
    func canAddInput(_: AVCaptureInput) -> Bool
    func addInput(_ input: AVCaptureInput)
    func canAddOutput(_ output: AVCaptureOutput) -> Bool
    func addOutput(_ output: AVCaptureOutput)
    func commitConfiguration()
    func startRunning()
    func stopRunning()
}

protocol PHPhotoLibraryContract {
    func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: ((Bool, Error?) -> Void)?)
}

extension AVCaptureDeviceContract {
    private var realDevice: AVCaptureDevice? {
        self as? AVCaptureDevice ?? nil
    }
    
    var activeFormat: AVCaptureDeviceFormatContract {
        get {
            return realDevice?.activeFormat ?? EmptyAVCaptureDeviceFormat()
        }
        set {
            if let realDevice {
                realDevice.activeFormat = newValue
            }
        }
    }
}

private class EmptyAVCaptureDeviceFormat: AVCaptureDeviceFormatContract {}

// ***************************************************************

protocol AVCaptureDeviceFormatContract {
    var minISO: Float { get }
    var maxISO: Float { get }
    var minExposureDuration: CMTime { get }
    var maxExposureDuration: CMTime { get }
}

extension AVCaptureDevice.Format: AVCaptureDeviceFormatContract {}

extension AVCaptureDeviceFormatContract {
    
    private var realFormat: AVCaptureDevice.Format? {
        self as? AVCaptureDevice.Format ?? nil
    }
    
    var minISO: Float {
        self.realFormat?.minISO ?? Float.assert()
    }
    
    var maxISO: Float {
        self.realFormat?.maxISO ?? Float.assert()
    }
    
    var minExposureDuration: CMTime {
        return realFormat?.minExposureDuration ?? CMTime.assert()
    }
    
    var maxExposureDuration: CMTime {
        return realFormat?.maxExposureDuration ?? CMTime.assert()
    }
}

fileprivate extension Float {
    static func assert() -> Self {
        Swift.assert(false)
        return Float(0)
    }
}

fileprivate extension CMTime {
    static func assert() -> Self {
        Swift.assert(false)
        return CMTimeMake(value: 1, timescale: 1)
    }
}

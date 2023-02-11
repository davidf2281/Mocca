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
extension AVCaptureDevice.Format:     AVCaptureDeviceFormatContract {}
extension CMFormatDescription:        CMFormatDescriptionContract {}

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
    var formats: [AVCaptureDevice.Format] { get }
}

extension AVCaptureDeviceContract {
    private var realDevice: (some AVCaptureDevice)? {
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
    
    var formats: [AVCaptureDeviceFormatContract] {
        if let realDevice {
            return (realDevice as AVCaptureDevicePropertyUnshadowing).formats
        }
        return []
    }
}

extension AVCaptureDevice : AVCaptureDevicePropertyUnshadowing {}

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

protocol CMFormatDescriptionContract {
    var dimensions: CMVideoDimensions { get }
    var mediaSubType: CMFormatDescription.MediaSubType { get }
}

extension CMFormatDescriptionContract {

    var dimensions: CMVideoDimensions {
        return realDescription?.dimensions ?? assert(CMVideoDimensions(width: 0, height: 0))
    }
    
    var mediaSubType: CMFormatDescription.MediaSubType {
        return realDescription?.mediaSubType ?? assert(CMFormatDescription.MediaSubType.pixelFormat_32BGRA)
    }
    
    private var realDescription: CMFormatDescription? {
        guardedCast(self)
    }
    
    private func guardedCast<T>(_ value: T) -> CMFormatDescription? {
        guard CFGetTypeID(value as CFTypeRef) == CMFormatDescription.self.typeID else {
            return nil
        }
        return (value as! CMFormatDescription)
    }
}

private class EmptyCMFormatDescription: CMFormatDescriptionContract {}

private class EmptyAVCaptureDeviceFormat: AVCaptureDeviceFormatContract {}

protocol AVCaptureDeviceFormatContract: AnyObject {
    var minISO: Float { get }
    var maxISO: Float { get }
    var minExposureDuration: CMTime { get }
    var maxExposureDuration: CMTime { get }
    var formatDescription: CMFormatDescriptionContract { get }
}

extension AVCaptureDeviceFormatContract {
    
    private var realFormat: AVCaptureDevice.Format? {
        self as? AVCaptureDevice.Format ?? nil
    }
    
    var minISO: Float {
        self.realFormat?.minISO ?? assert(0)
    }
    
    var maxISO: Float {
        self.realFormat?.maxISO ?? assert(0)
    }
    
    var minExposureDuration: CMTime {
        return realFormat?.minExposureDuration ?? assert(CMTime.zero)
    }
    
    var maxExposureDuration: CMTime {
        return realFormat?.maxExposureDuration ?? assert(CMTime.zero)
    }
    
    var formatDescription: CMFormatDescriptionContract {
        return realFormat?.formatDescription ?? assert(EmptyCMFormatDescription())
    }
}

fileprivate func assert<T>(_ value: T) -> T {
    Swift.assert(false)
    return value
}

//
//  CaptureManager.swift
//  Mocca
//
//  Created by David Fearon on 05/10/2020.
//

import Foundation
import AVFoundation

enum CaptureManagerError: Error {
    case captureDeviceNotFound
    case addVideoInputFailed
    case addVideoOutputFailed
    case findFullRangeVideoFormatFailed
    case setIsoFailed
    case setExposureFailed
    case unknown
}

protocol CaptureManager {
    
    var captureSession : TestableAVCaptureSession { get }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? { get set }
    var isExposurePointOfInterestSupported: Bool { get }
    func startCaptureSession ()
    func stopCaptureSession ()
    func currentPhotoSettings() -> AVCapturePhotoSettings
    func capturePhoto(settings:AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate)
    func minIsoForActiveDevice() -> Float
    func maxIsoForActiveDevice() -> Float
    func setIsoForActiveDevice(iso : Float, completion: @escaping (CMTime) -> Void) throws
    func maxExposureSecondsForActiveDevice() -> Float64
    func minExposureSecondsForActiveDevice() -> Float64
    func setExposure(seconds : Float64, completion: @escaping (CMTime) -> Void) throws
    func setExposurePointOfInterest(_ point:CGPoint) -> Outcome
    func setFocusPointOfInterest(_ point:CGPoint) -> Outcome
    func currentOutputAspectRatio() -> CGFloat?
}

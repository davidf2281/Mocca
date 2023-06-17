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
    case addVideoDataOutputFailed
    case addPhotoOutputFailed
    case findFullRangeVideoFormatFailed
    case setIsoFailed
    case setExposureFailed
    case setExposureTargetBiasFailed
    case unknown
}

protocol CaptureManagerContract {
    var activeCaptureDevice: AVCaptureDeviceContract { get }
    var videoPreviewLayer: AVCaptureVideoPreviewLayerContract? { get set }
    func startCaptureSession ()
    func stopCaptureSession ()
    func selectCamera(type: LogicalCameraDevice) -> Result<Void, CaptureManagerError>
    func currentPhotoSettings() -> AVCapturePhotoSettings
    func capturePhoto(settings:AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate)
    func setSampleBufferDelegate(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
                                 queue callbackQueue: DispatchQueue)
}
//
//  CaptureManager.swift
//  Mocca
//
//  Created by David Fearon on 05/10/2020.
//

import Foundation

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

enum CaptureManagerConfigError: Error {
    case captureDeviceNotFound
    case videoPreviewLayerNil
}

protocol CaptureManagerContract {
    var activeCaptureDevice: CaptureDevice { get }
    
    // Capture manager requires a reference to the video preview layer to convert view coords to camera-device coords using
    // AVCaptureVideoPreviewLayer's point-conversion functions. Only the preview layer can do this.
    var videoPreviewLayer: CaptureVideoPreviewLayer { get }
    var captureSession : CaptureSession { get }
    func startCaptureSession ()
    func stopCaptureSession ()
    func selectCamera(type: LogicalCameraDevice) -> Result<Void, CaptureManagerError>
    func setSampleBufferDelegate(_ delegate: CaptureVideoDataOutputSampleBufferDelegate,
                                 queue callbackQueue: DispatchQueue)
}

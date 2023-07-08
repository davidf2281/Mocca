//
//  SessionManager.swift
//  Mocca
//
//  Created by David Fearon on 05/10/2020.
//

import Foundation

enum SessionManagerError: Error {
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

enum SessionManagerConfigError: Error {
    case captureDeviceNotFound
    case videoPreviewLayerNil
}

protocol SessionManagerContract {
    var activeCaptureDevice: CaptureDevice { get }
    var activeCamera: PhysicalCamera { get }
    // Session manager requires a reference to the video preview layer to convert view coords to camera-device coords using
    // AVCaptureVideoPreviewLayer's point-conversion functions. Only the preview layer can do this.
    var videoPreviewLayer: CaptureVideoPreviewLayer { get }
    var captureSession : CaptureSession { get }
    func startCaptureSession()
    func stopCaptureSession()
    func selectCamera(cameraID: UUID) -> Result<Void, SessionManagerError>
}

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

extension AVCaptureDevice:      TestableAVCaptureDevice      { /* Empty extension: required. */ }
extension AVCaptureDeviceInput: TestableAVCaptureDeviceInput { /* Empty extension: required. */ }
extension AVCaptureSession:     TestableAVCaptureSession     { /* Empty extension: required. */ }
extension PHPhotoLibrary:       TestablePHPhotoLibrary       { /* Empty extension: required. */ }

protocol TestableAVCaptureDevice {
    var activeFormat: AVCaptureDevice.Format { get set }
    var formats: [AVCaptureDevice.Format] { get }
    var activeVideoMinFrameDuration: CMTime { get set }
    var exposureDuration: CMTime { get }
    var isExposurePointOfInterestSupported: Bool { get }
    var exposurePointOfInterest: CGPoint { get set }
    var exposureMode: AVCaptureDevice.ExposureMode { get set }
    var focusPointOfInterest: CGPoint { get set }
    var focusMode: AVCaptureDevice.FocusMode { get set }
    func setFocusModeLocked(lensPosition: Float, completionHandler handler: ((CMTime) -> Void)?)
    func setExposureModeCustom(duration: CMTime, iso ISO: Float, completionHandler handler: ((CMTime) -> Void)?)
    func lockForConfiguration() throws
    func unlockForConfiguration()
}

protocol TestableAVCaptureDeviceInput {}

protocol TestableAVCaptureSession {
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

protocol TestablePHPhotoLibrary {
    func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: ((Bool, Error?) -> Void)?)
}


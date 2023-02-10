//
//  CaptureUtils.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

protocol CaptureUtilsContract {
    func minIso(for device:AVCaptureDeviceContract) -> Float
    func maxIso(for device:AVCaptureDeviceContract) -> Float
    func maxExposureSeconds(for device:AVCaptureDeviceContract) -> Float64
    func minExposureSeconds(for device:AVCaptureDeviceContract) -> Float64
}

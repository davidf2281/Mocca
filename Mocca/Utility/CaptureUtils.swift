//
//  CaptureUtils.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

protocol CaptureUtils {
    func minIso(for device:TestableAVCaptureDevice) -> Float
    func maxIso(for device:TestableAVCaptureDevice) -> Float
    func maxExposureSeconds(for device:TestableAVCaptureDevice) -> Float64
    func minExposureSeconds(for device:TestableAVCaptureDevice) -> Float64
    func aspectRatio(for format:AVCaptureDevice.Format) -> CGFloat
}

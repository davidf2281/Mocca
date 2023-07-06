//
//  CaptureUtils.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation

protocol CaptureUtilsContract {
    func minIso(for device:CaptureDevice) -> Float
    func maxIso(for device:CaptureDevice) -> Float
    func maxExposureSeconds(for device:CaptureDevice) -> Float64
    func minExposureSeconds(for device:CaptureDevice) -> Float64
}

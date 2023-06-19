//
//  MockCaptureUtils.swift
//  MoccaTests
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockCaptureUtils: CaptureUtilsContract {
    
    var minIsoToReturn: Float = 100
    func minIso(for device: CaptureDevice) -> Float {
        return minIsoToReturn
    }
    
    var maxIsoToReturn: Float = 3200
    func maxIso(for device: CaptureDevice) -> Float {
        return maxIsoToReturn
    }
    
    var minExposureSecondsToReturn: Float64 = 0.001
    func minExposureSeconds(for device: CaptureDevice) -> Float64 {
        return minExposureSecondsToReturn
    }
    
    var maxExposureSecondsToReturn: Float64 = 0.3
    func maxExposureSeconds(for device: CaptureDevice) -> Float64 {
        return maxExposureSecondsToReturn
    }
    
//    var aspectRatioToReturn: CGFloat = 0.75
//    func aspectRatio(for format: AVCaptureDevice.Format) -> CGFloat {
//        return aspectRatioToReturn
//    }
}

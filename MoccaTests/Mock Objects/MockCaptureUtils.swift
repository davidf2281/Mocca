//
//  MockCaptureUtils.swift
//  MoccaTests
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockCaptureUtils: CaptureUtils {
    func minIso(for device: TestableAVCaptureDevice) -> Float {
        return 100
    }
    
    func maxIso(for device: TestableAVCaptureDevice) -> Float {
        return 3200
    }
    
    func maxExposureSeconds(for device: TestableAVCaptureDevice) -> Float64 {
        0.3
    }
    
    func minExposureSeconds(for device: TestableAVCaptureDevice) -> Float64 {
        0.001
    }
    
    func aspectRatio(for format: AVCaptureDevice.Format) -> CGFloat {
        return 0.75
    }
    
    
}

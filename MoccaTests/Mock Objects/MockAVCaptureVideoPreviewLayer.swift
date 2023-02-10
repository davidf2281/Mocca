//
//  File.swift
//  MoccaTests
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockAVCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayerContract {
    
    var lastPointInLayer: CGPoint? = nil
    func captureDevicePointConverted(fromLayerPoint pointInLayer: CGPoint) -> CGPoint {
        lastPointInLayer = pointInLayer
        return pointInLayer
    }
}

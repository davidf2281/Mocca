//
//  File.swift
//  MoccaTests
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockCaptureVideoPreviewLayer: CaptureVideoPreviewLayer {
    
    var captureConnection: CaptureConnection? = nil // TODO: Mock
    var captureSession: CaptureSession? = nil // TODO: Mock
    var lastPointInLayer: CGPoint? = nil
    var gravity: LayerGravity = .resize
    var frame: CGRect = .zero
    
    func captureDevicePointConverted(fromLayerPoint pointInLayer: CGPoint) -> CGPoint {
        lastPointInLayer = pointInLayer
        return pointInLayer
    }
}


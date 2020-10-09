//
//  MockAVCaptureSession.swift
//  MoccaTests
//
//  Created by David Fearon on 25/07/2019.
//  Copyright © 2019 --. All rights reserved.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockAVCaptureSession: TestableAVCaptureSession {
    
    var sessionPreset: AVCaptureSession.Preset = .inputPriority
    
    var canAddInput : Bool = false
    var canAddOutput : Bool = false

    func beginConfiguration() {}
    
    func canAddInput(_: AVCaptureInput) -> Bool {
        return self.canAddInput
    }
    
    func addInput(_ input: AVCaptureInput) {}
    
    func canAddOutput(_ output: AVCaptureOutput) -> Bool {
        return self.canAddOutput
    }
    
    func addOutput(_ output: AVCaptureOutput) {}
    
    func commitConfiguration() {}
    
    func startRunning() {}
    
    func stopRunning() {}
}

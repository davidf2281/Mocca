//
//  MockAVCapturePhotoOutput.swift
//  MoccaTests
//
//  Created by David Fearon on 18/10/2020.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockAVCapturePhotoOutput: TestableAVCapturePhotoOutput {
    
    var isHighResolutionCaptureEnabled: Bool = true
    var isLivePhotoCaptureEnabled: Bool = false
    
    // Test vars
    var capturePhotoCalled = false
    var lastphotoCaptureSettings: AVCapturePhotoSettings?
    
    func capturePhoto(with settings: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate) {
        self.capturePhotoCalled = true
        self.lastphotoCaptureSettings = settings
    }
    
    func connection(with: AVMediaType) -> AVCaptureConnection? {
        return nil
    }
}

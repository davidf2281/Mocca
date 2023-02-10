//
//  MockAVCaptureDevice.swift
//  MoccaTests
//
//  Created by David Fearon on 23/07/2019.
//  Copyright © 2019 --. All rights reserved.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockAVCaptureDevice: AVCaptureDeviceContract {

    // Test vars
    var exposureMode                                = AVCaptureDevice.ExposureMode.autoExpose// MARK: TODO
    var configurationLocked : Bool                  = false
    var configurationWasLocked : Bool               = false
    var configurationWasUnlocked : Bool             = false
    var configurationWasUnlockedAfterLocking : Bool = false
    var configurationChangedWithoutLock             = false
    var focusModeSetLocked                          = false
    var exposurePointOfInterestCalled = false
    var focusPointOfInterestCalled = false
    
    // Protocol conformance
    var iso: Float = 0
    var focusMode: AVCaptureDevice.FocusMode = .locked
    var isExposurePointOfInterestSupported = false// MARK: TODO
    var exposureTargetBias: Float = 0
    var maxExposureTargetBias: Float = 3
    var minExposureTargetBias: Float = 3
    
    var focusPointOfInterest = CGPoint.zero {
        willSet {
            focusPointOfInterestCalled = true
        }
    }
    
    var exposurePointOfInterest = CGPoint.zero {
        willSet {
            exposurePointOfInterestCalled = true
        }
    }
    func setExposureTargetBias(_ bias: Float, completionHandler handler: ((CMTime) -> Void)?) {
        self.exposureTargetBias = bias
    }

    var setLensPosition : Float?
    var activeFormat: AVCaptureDeviceFormatContract = MockAVCaptureDeviceFormat()
    var formats: [AVCaptureDevice.Format] = []
    var activeVideoMinFrameDuration: CMTime = .zero
    var exposureDuration: CMTime = .zero
    
    func setFocusModeLocked(lensPosition: Float, completionHandler handler: ((CMTime) -> Void)?) {
        if (self.configurationLocked != true) {
            self.configurationChangedWithoutLock = true
            return
        }
        
        self.focusModeSetLocked = true
        self.setLensPosition = lensPosition
    }
    
    func setExposureModeCustom(duration: CMTime, iso ISO: Float, completionHandler handler: ((CMTime) -> Void)?) {
        if (self.configurationLocked != true) {
            self.configurationChangedWithoutLock = true
            return
        }
        self.exposureDuration = duration
        self.iso = ISO
    }
    
    func lockForConfiguration() throws {
        self.configurationLocked = true
        self.configurationWasLocked = true
    }
    
    func unlockForConfiguration() {
        self.configurationWasUnlocked = true
        self.configurationLocked = false
        if (self.configurationWasLocked == true) {
            self.configurationWasUnlockedAfterLocking = true
        }
    }
}


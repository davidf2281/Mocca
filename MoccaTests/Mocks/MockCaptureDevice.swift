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

class MockCaptureDevice: CaptureDevice {
   
    struct LockForConfigurationError: Error {}
    
    // Test vars
    var exposureMode: AVCaptureDevice.ExposureMode  = .locked
    var configurationLocked : Bool                  = false
    var configurationWasLocked : Bool               = false
    var configurationWasUnlocked : Bool             = false
    var configurationWasUnlockedAfterLocking : Bool = false
    var configurationChangedWithoutLock             = false
    var focusModeSetLocked                          = false
    var exposurePointOfInterestSet = false
    var focusPointOfInterestSet = false
    
    // Protocol conformance
    var iso: Float = 0
    var focusMode: AVCaptureDevice.FocusMode = .locked
    var isExposurePointOfInterestSupported = false// MARK: TODO
    var exposureTargetBias: Float = 0
    var maxExposureTargetBias: Float = 3
    var minExposureTargetBias: Float = 3
    
    var focusPointOfInterest = CGPoint.zero {
        willSet {
            focusPointOfInterestSet = true
        }
    }
    
    var exposurePointOfInterest = CGPoint.zero {
        willSet {
            exposurePointOfInterestSet = true
        }
    }
    func setExposureTargetBias(_ bias: Float, completionHandler handler: ((CMTime) -> Void)?) {
        self.exposureTargetBias = bias
    }

    var setLensPosition : Float?
    var activeFormat: CaptureDeviceFormat = MockAVCaptureDeviceFormat()
    var formatsToReturn: [CaptureDeviceFormat] = [MockAVCaptureDeviceFormat()]
    var formats: [CaptureDeviceFormat] {
        formatsToReturn
    }
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
    
    var lockForConfigurationShouldFail = false
    func lockForConfiguration() throws {
        if lockForConfigurationShouldFail {
            throw(LockForConfigurationError())
        }
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
    
    var deviceTypeSet: CaptureDeviceType?
    var positionSet: CaptureDevicePosition?
    var captureDeviceCallCount = 0
    var captureDeviceToReturn: CaptureDevice?
    func captureDevice(withType deviceType: CaptureDeviceType, position: CaptureDevicePosition) -> CaptureDevice? {
        deviceTypeSet = deviceType
        positionSet = position
        captureDeviceCallCount += 1
        return captureDeviceToReturn
    }
    
    var exposurePointOfInterestSupportedToReturn = true
    var exposurePointOfInterestSupported: Bool {
        exposurePointOfInterestSupportedToReturn
    }
    
    var focusPointOfInterestSupportedToReturn = true
    var focusPointOfInterestSupported: Bool {
        focusPointOfInterestSupportedToReturn
    }
}

//
//  MockResources.swift
//  MoccaTests
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockResources: Resources {
    
    var deviceToReturn: TestableAVCaptureDevice?
    
    // Test vars
    var physicalDeviceCallShouldSucceed = true
    // Protocol conformance
    func anyAvailableCamera(preferredDevice: LogicalCameraDevice, supportedCameraDevices: [LogicalCameraDevice]) -> TestableAVCaptureDevice? {
        
        if let device = self.deviceToReturn {
            return device
        } else {
            assert(false, "deviceToReturn not set")
        }
        
        return nil
    }
    
    func physicalDevice(from logicalDevice: LogicalCameraDevice) -> TestableAVCaptureDevice? {
        
        if (physicalDeviceCallShouldSucceed == false) {
            return nil
        }
        
        if let device = self.deviceToReturn {
            return device
        } else {
            assert(false, "deviceToReturn not set")
        }
        
        return nil
    }
    
    
}

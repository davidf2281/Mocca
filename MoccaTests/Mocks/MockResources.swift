//
//  MockResources.swift
//  MoccaTests
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockResources: DeviceResourcesContract {
    
    // Test vars
    var physicalDeviceCallShouldSucceed = true
    
    // Protocol conformance

    var deviceToReturn: CaptureDevice?
    var metalDevice: MTLDevice? = MTLCreateSystemDefaultDevice()
    
    func anyAvailableCamera(preferredDevice: LogicalCameraDevice, supportedCameraDevices: [LogicalCameraDevice]) -> CaptureDevice? {
        return deviceToReturn
    }
    
    func physicalDevice(from logicalDevice: LogicalCameraDevice) -> CaptureDevice? {
        
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

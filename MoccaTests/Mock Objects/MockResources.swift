//
//  MockResources.swift
//  MoccaTests
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockResources: ResourcesContract {
    
    // Test vars
    var physicalDeviceCallShouldSucceed = true
    
    // Protocol conformance

    var deviceToReturn: AVCaptureDeviceContract?
    var metalDevice: MTLDevice? = MTLCreateSystemDefaultDevice()
    
    func anyAvailableCamera(preferredDevice: LogicalCameraDevice, supportedCameraDevices: [LogicalCameraDevice]) -> AVCaptureDeviceContract? {
        return nil
    }
    
    func physicalDevice(from logicalDevice: LogicalCameraDevice) -> AVCaptureDeviceContract? {
        
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

//
//  DeviceResources.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

protocol DeviceResourcesContract {
    
    var metalDevice: MTLDevice? { get }
    var availablePhysicalDevices: [CaptureDevice] { get }
    func anyAvailableCamera(preferredDevice:LogicalCameraDevice) -> CaptureDevice?
    func physicalDevice(from logicalDevice: LogicalCameraDevice) -> CaptureDevice?
}

class DeviceResources: DeviceResourcesContract {
            
    private(set) var metalDevice: MTLDevice? = MTLCreateSystemDefaultDevice()
    private let captureDevice: CaptureDevice
    private let supportedCameraDevices: [LogicalCameraDevice]
    
    var availablePhysicalDevices: [CaptureDevice] {
        self.captureDevice.availablePhysicalDevices(for: self.supportedCameraDevices)
    }
    
    init?(captureDevice: CaptureDevice?, supportedCameraDevices: [LogicalCameraDevice]) {
        guard let captureDevice else {
            return nil
        }
        
        self.captureDevice = captureDevice
        self.supportedCameraDevices = supportedCameraDevices
    }
    
    /// Searches for an available physical camera within the supplied array of supported logical camera device types.
    /// - Parameter preferredDevice: The preferred type to return.
    /// - Parameter supportedCameraDevices: An array of CameraDevice
    /// - Returns: A physical camera of the preferred type, the first available if the preferred choice is not found, or nil if none are found.
    func anyAvailableCamera(preferredDevice:LogicalCameraDevice) -> CaptureDevice? {
        
        if supportedCameraDevices.contains(preferredDevice) {
            if let device = physicalDevice(from: preferredDevice) {
                return device
            }
        }
        
        for supportedDevice in supportedCameraDevices {
            if let device = physicalDevice(from: supportedDevice) {
                return device
            }
        }
        
        return nil
    }
    
    func physicalDevice(from logicalDevice: LogicalCameraDevice) -> CaptureDevice? {
        return self.captureDevice.captureDevice(withType: logicalDevice.type, position: logicalDevice.position)
    }
}

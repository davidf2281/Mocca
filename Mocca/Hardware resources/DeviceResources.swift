//
//  DeviceResources.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

class DeviceResources: Resources {
    
    static let shared = DeviceResources()
    
    private init() {}
    
    public private(set) var metalDevice: MTLDevice? = MTLCreateSystemDefaultDevice()
    
    /// Searches for an available physical camera within the supplied array of supported logical camera device types.
    /// - Parameter preferredDevice: The preferred type to return.
    /// - Parameter supportedCameraDevices: An array of CameraDevice
    /// - Returns: A physical camera of the preferred type, the first available if the preferred choice is not found, or nil if none are found.
    func anyAvailableCamera(preferredDevice:LogicalCameraDevice,
                                          supportedCameraDevices: [LogicalCameraDevice]) -> TestableAVCaptureDevice? {
        
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
    
    func physicalDevice(from logicalDevice: LogicalCameraDevice) -> TestableAVCaptureDevice? {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [logicalDevice.type], mediaType: .video, position: logicalDevice.position)
        if let device = session.devices.first {
            return device
        }
        
        return nil
    }
}

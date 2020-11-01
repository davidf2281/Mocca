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
                                          supportedCameraDevices: [LogicalCameraDevice]) -> AvailableCamera? {
        
        if supportedCameraDevices.contains(preferredDevice) {
            if let camera = availableCamera(from: preferredDevice) {
                return camera
            }
        }
        
        for supportedDevice in supportedCameraDevices {
            if let device = availableCamera(from: supportedDevice) {
                return device
            }
        }
        
        return nil
    }
    
    func allAvailableCameras(in logicalDevices:[LogicalCameraDevice]) -> [AvailableCamera] {
        
        var availableCameras:[AvailableCamera] = []
        
        for logicalDevice in logicalDevices {
            if let camera = availableCamera(from: logicalDevice) {
                availableCameras.append(camera)
                print("fov: \(camera.captureDevice.activeFormat.videoFieldOfView)")
            }
        }
        
        return availableCameras
    }
    
    func availableCamera(from logicalDevice: LogicalCameraDevice) -> AvailableCamera? {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [logicalDevice.type], mediaType: .video, position: logicalDevice.position)
        if let camera = session.devices.first {
            return AvailableCamera(camera: camera, position: logicalDevice.position)
        }
        
        return nil
    }
}

//
//  Resources.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

protocol Resources {
    
    var metalDevice: MTLDevice? { get }
    
    func anyAvailableCamera(preferredDevice:LogicalCameraDevice,
                            supportedCameraDevices: [LogicalCameraDevice]) -> AVCaptureDeviceContract?
    
    func physicalDevice(from logicalDevice: LogicalCameraDevice) -> AVCaptureDeviceContract?
}

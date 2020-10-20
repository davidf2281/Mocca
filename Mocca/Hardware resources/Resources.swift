//
//  Resources.swift
//  Mocca
//
//  Created by David Fearon on 20/10/2020.
//

import Foundation
import AVFoundation

protocol Resources {
    func anyAvailableCamera(preferredDevice:LogicalCameraDevice,
                            supportedCameraDevices: [LogicalCameraDevice]) -> TestableAVCaptureDevice?
    
    func physicalDevice(from logicalDevice: LogicalCameraDevice) -> TestableAVCaptureDevice?
}

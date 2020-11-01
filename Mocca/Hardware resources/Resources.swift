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
                                          supportedCameraDevices: [LogicalCameraDevice]) -> AvailableCamera?
    
    func availableCamera(from logicalDevice: LogicalCameraDevice) -> AvailableCamera?
}

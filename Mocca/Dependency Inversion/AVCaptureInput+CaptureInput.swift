//
//  AVCaptureInput+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation

extension AVCaptureInput: CaptureInput {}

extension AVCaptureDeviceInput: CaptureDeviceInput {
    
    static func make(device: CaptureDevice) throws -> CaptureDeviceInput  {
        guard let device = device as? AVCaptureDevice else {
            throw MakeCaptureDeviceInputError.failed
        }
        
        return try Self.init(device: device)
    }
}

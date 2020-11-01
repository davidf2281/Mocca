//
//  AvailableCamera.swift
//  Mocca
//
//  Created by David Fearon on 31/10/2020.
//

import Foundation
import AVFoundation

typealias FOV = Float

class AvailableCamera {
    let position: AVCaptureDevice.Position

    var fov: FOV {
        return self.captureDevice.activeFormat.videoFieldOfView
    }
    
    let captureDevice: AVCaptureDevice
    
    required init(camera: AVCaptureDevice, position: AVCaptureDevice.Position) {
        self.captureDevice = camera
        self.position = position
    }
}

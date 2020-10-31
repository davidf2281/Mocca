//
//  AvailableCamera.swift
//  Mocca
//
//  Created by David Fearon on 31/10/2020.
//

import Foundation

typealias FOV = Float

class AvailableCamera {
    
    var fov: FOV {
        return self.captureDevice.activeFormat.videoFieldOfView
    }
    
    let captureDevice: TestableAVCaptureDevice
    
    required init(camera: TestableAVCaptureDevice) {
        self.captureDevice = camera
    }
}

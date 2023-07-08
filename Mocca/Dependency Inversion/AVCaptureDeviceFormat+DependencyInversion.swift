//
//  AVCaptureDeviceFormat+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation

extension AVCaptureDevice.Format: CaptureDeviceFormat {
    var maxPhotoDimensions: [CMVideoDimensions] {
        self.supportedMaxPhotoDimensions
    }
}

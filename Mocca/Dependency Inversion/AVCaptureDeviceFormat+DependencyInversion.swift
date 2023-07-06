//
//  AVCaptureDeviceFormat+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation

protocol CaptureDeviceFormat: AnyObject {
    var minISO: Float { get }
    var maxISO: Float { get }
    var minExposureDuration: CMTime { get }
    var maxExposureDuration: CMTime { get }
    var formatDescription: FormatDescription { get }
    var maxPhotoDimensions: [CMVideoDimensions] { get }
}

extension AVCaptureDevice.Format: CaptureDeviceFormat {
    var maxPhotoDimensions: [CMVideoDimensions] {
        self.supportedMaxPhotoDimensions
    }
}

extension CaptureDeviceFormat {
    
    private var realFormat: AVCaptureDevice.Format {
        guard let self = self as? AVCaptureDevice.Format else {
            fatalError()
        }
        return self
    }
    
    var minISO: Float {
        self.realFormat.minISO
    }
    
    var maxISO: Float {
        self.realFormat.maxISO
    }
    
    var minExposureDuration: CMTime {
        return realFormat.minExposureDuration
    }
    
    var maxExposureDuration: CMTime {
        return realFormat.maxExposureDuration
    }
    
    var formatDescription: FormatDescription {
        return realFormat.formatDescription
    }
}

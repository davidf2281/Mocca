//
//  CaptureDeviceFormat.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation
import AVFoundation.AVCaptureDevice

protocol CaptureDeviceFormat: AnyObject {
    var minISO: Float { get }
    var maxISO: Float { get }
    var minExposureDuration: CMTime { get }
    var maxExposureDuration: CMTime { get }
    var formatDescription: FormatDescription { get }
    var maxPhotoDimensions: [CMVideoDimensions] { get }
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

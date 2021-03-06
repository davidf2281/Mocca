//
//  CaptureUtils.swift
//  Mocca
//
//  Created by David Fearon on 25/07/2019.
//  Copyright © 2019 --. All rights reserved.
//

import Foundation
import AVFoundation

struct DeviceCaptureUtils: CaptureUtils {
    
    public func minIso(for device:TestableAVCaptureDevice) -> Float {
        let minIso = device.activeFormat.minISO
        return minIso
    }
    
    public func maxIso(for device:TestableAVCaptureDevice) -> Float {
        let maxIso = device.activeFormat.maxISO
        return maxIso
    }
    
    public func maxExposureSeconds(for device:TestableAVCaptureDevice) -> Float64 {
        let maxDuration = device.activeFormat.maxExposureDuration
        return CMTimeGetSeconds(maxDuration)
    }
    
    public func minExposureSeconds(for device:TestableAVCaptureDevice) -> Float64 {
        let minDuration = device.activeFormat.minExposureDuration
        return CMTimeGetSeconds(minDuration)
    }
    
    public func highestResolutionFullRangeVideoFormat(_ device:TestableAVCaptureDevice) -> AVCaptureDevice.Format? {
        
        var highestPixelCount : UInt = 0
        var returnFormat : AVCaptureDevice.Format? = nil
        
        for format in device.formats {
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            let pixelCount = UInt(dimensions.height * dimensions.width)
            let description = CMFormatDescriptionGetMediaSubType(format.formatDescription)
            
            if description == fourTwentyFCode() && pixelCount > highestPixelCount {
                highestPixelCount = pixelCount
                returnFormat = format
            }
        }
        
        return returnFormat
    }
    
    public func aspectRatio(for format:AVCaptureDevice.Format) -> CGFloat {
        let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
        return CGFloat(dimensions.width / dimensions.height)
    }
    
    /// Computes a byte code corresponding to the 420f full-range pixel format
    /// - Returns: A FourCharCode representing the 420f pixel format identifier
    private func fourTwentyFCode() -> FourCharCode {
        var code = FourCharCode(0)
        for byte in "420f".utf8 {
            code = code << 8 + FourCharCode(byte)
        }
        return code
    }
}

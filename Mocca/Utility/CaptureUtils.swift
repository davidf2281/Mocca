//
//  CaptureUtils.swift
//  Mocca
//
//  Created by David Fearon on 25/07/2019.
//  Copyright © 2019 --. All rights reserved.
//

import Foundation
import CoreMedia.CMTime

struct CaptureUtils: CaptureUtilsContract {
    
    func minIso(for device:CaptureDevice) -> Float {
        let minIso = device.activeFormat.minISO
        return minIso
    }
    
    func maxIso(for device:CaptureDevice) -> Float {
        let maxIso = device.activeFormat.maxISO
        return maxIso
    }
    
    func maxExposureSeconds(for device:CaptureDevice) -> Float64 {
        let maxDuration = device.activeFormat.maxExposureDuration
        return CMTimeGetSeconds(maxDuration)
    }
    
    func minExposureSeconds(for device:CaptureDevice) -> Float64 {
        let minDuration = device.activeFormat.minExposureDuration
        return CMTimeGetSeconds(minDuration)
    }
    
    func highestResolutionFullRangeVideoFormat(_ device:CaptureDevice) -> CaptureDeviceFormat? {
   
        let fourTwentyFormats = device.formats.compactMap {
            let mediaSubType = $0.formatDescription.mediaSubType.rawValue
            return mediaSubType == fourTwentyFCode() ? $0 : nil
        }
        
        return highestResolutionFormat(fourTwentyFormats)
    }
    
    private func highestResolutionFormat(_ formats: [CaptureDeviceFormat]) -> CaptureDeviceFormat? {
            var highestPixelCount = 0
            var returnFormat : CaptureDeviceFormat? = nil
            for format in formats {
                let pixelCount = format.formatDescription.dimensions.width * format.formatDescription.dimensions.height
                if pixelCount > highestPixelCount {
                    highestPixelCount = Int(pixelCount)
                    returnFormat = format
                }
            }
            
            return returnFormat
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

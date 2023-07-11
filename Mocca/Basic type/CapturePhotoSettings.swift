//
//  CapturePhotoSettings.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation
import CoreMedia.CMFormatDescription

enum PhotoQualityPrioritization {
    case quality
    case unsupported
}

enum PhotoFlashMode {
    case on
    case off
    case auto
    case unsupported
}

protocol CapturePhotoSettings: AnyObject {
    var qualityPrioritization: PhotoQualityPrioritization { get set }
    var photoFlashMode: PhotoFlashMode { get set }
    var maximumPhotoDimensions: CMVideoDimensions { get set }
}

//
//  AVCapturePhotoSettings+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation

protocol CapturePhotoSettings {
    var qualityPrioritization: PhotoQualityPrioritization { get set }
    var photoFlashMode: PhotoFlashMode { get set }
    var maximumPhotoDimensions: CMVideoDimensions { get set }
}

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

extension AVCapturePhotoSettings: CapturePhotoSettings {
    var photoFlashMode: PhotoFlashMode {
        get {
            switch self.flashMode {
                case .off:
                    return .off
                case .on:
                    return .on
                case .auto:
                    return .auto
                @unknown default:
                    return .unsupported
            }
        }
        set {
            switch newValue {
                case .on:
                    self.flashMode = .on
                case .off:
                    self.flashMode = .off
                case .auto:
                    self.flashMode = .auto
                case .unsupported:
                    assert(false)
            }
        }
    }
    
    var qualityPrioritization: PhotoQualityPrioritization {
        get {
            switch self.photoQualityPrioritization {
                case .quality:
                    return .quality
                default:
                    return .unsupported
            }
        }
        set {
            switch newValue {
                case .quality:
                    self.photoQualityPrioritization = .quality
                case .unsupported:
                    assert(false)
            }
        }
    }
    
    var maximumPhotoDimensions: CMVideoDimensions {
        get {
            self.maxPhotoDimensions
        }
        
        set {
            self.maxPhotoDimensions = newValue
        }
    }
}

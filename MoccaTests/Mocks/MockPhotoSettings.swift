//
//  MockPhotoSettings.swift
//  MoccaTests
//
//  Created by David Fearon on 30/06/2023.
//

import Foundation
import CoreMedia
@testable import Mocca

class MockPhotoSettings: CapturePhotoSettings {
    var maximumPhotoDimensions: CMVideoDimensions = CMVideoDimensions(width: 0, height: 0)
    var qualityPrioritization: PhotoQualityPrioritization = .unsupported
    var photoFlashMode: PhotoFlashMode = .unsupported
}

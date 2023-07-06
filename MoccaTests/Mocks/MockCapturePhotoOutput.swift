//
//  MockCaptureOutput.swift
//  MoccaTests
//
//  Created by David Fearon on 29/06/2023.
//

import Foundation
import AVFoundation
import UIKit

@testable import Mocca

final class MockCapturePhotoOutput: CapturePhotoOutput {
 
    var livePhotoCaptureEnabled: Bool = false
    var maxQualityPrioritization: PhotoQualityPrioritization = .unsupported
    
    var capturePhotoSettingsSet: CapturePhotoSettings?
    var capturePhotoDelegateSet: CapturePhotoDelegate?
    var captureCallCount = 0
    func capture(with settings: CapturePhotoSettings, delegate: CapturePhotoDelegate) {
        captureCallCount += 1
        capturePhotoSettingsSet = settings
        capturePhotoDelegateSet = delegate
    }
    
    var connectionCallCount = 0
    func connection() -> CaptureConnection? {
        connectionCallCount += 1
        return MockConnection()
    }
    
    var availablePhotoCodecsToReturn: [PhotoCodec] = [.hevc]
    var availablePhotoCodecs: [PhotoCodec] {
        availablePhotoCodecsToReturn
    }
}

class MockConnection: CaptureConnection {
    var orientation: UIInterfaceOrientation = .portrait
}

//
//  MockAVCaptureDeviceInput.swift
//  MoccaTests
//
//  Created by David Fearon on 17/10/2020.
//

import Foundation
import AVFoundation
@testable import Mocca

class MockCaptureDeviceInput: CaptureDeviceInput {
    static func make(device: CaptureDevice) throws -> CaptureDeviceInput {
        return MockCaptureDeviceInput()
    }
}

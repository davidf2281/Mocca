//
//  CaptureInput.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation

protocol CaptureInput {}

protocol CaptureDeviceInput: CaptureInput {
    static func make(device: CaptureDevice) throws -> CaptureDeviceInput
}

enum MakeCaptureDeviceInputError: Error {
    case failed
}

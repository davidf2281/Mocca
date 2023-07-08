//
//  Camera.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation

protocol Camera {
    var type: CaptureDeviceType { get }
    var position: CaptureDevicePosition { get }
}

struct LogicalCamera: Camera, Equatable {
    let type: CaptureDeviceType
    let position: CaptureDevicePosition
}

struct PhysicalCamera: Camera, Identifiable {
    let id: UUID
    let type: CaptureDeviceType
    let position: CaptureDevicePosition
    let captureDevice: CaptureDevice
}

extension PhysicalCamera: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

//
//  CapturePhotoOutput.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation

protocol CaptureOutput {}

enum PhotoCodec {
    case hevc
}

protocol CapturePhotoOutput: AnyObject, CaptureOutput {
    init()
    var livePhotoCaptureEnabled: Bool { get set }
    var maxQualityPrioritization: PhotoQualityPrioritization { get set }
    func capture(with settings: CapturePhotoSettings, delegate: CapturePhotoDelegate)
    func connection() -> CaptureConnection?
    var availablePhotoCodecs: [PhotoCodec] { get }
}

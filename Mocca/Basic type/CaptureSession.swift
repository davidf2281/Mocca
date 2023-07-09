//
//  CaptureSession.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation

enum CaptureSessionPreset {
    case photo
    case unsupported
}

protocol CaptureSession: AnyObject {
    func beginConfiguration()
    func canAddInput(_ input: CaptureInput) -> Bool
    func addInput(_ input: CaptureInput)
    func removeInput(_ input: CaptureInput)
    func canAddOutput(_ output: CaptureOutput) -> Bool
    func addOutput(_ output: CaptureOutput)
    func commitConfiguration()
    func startRunning()
    func stopRunning()
    var preset: CaptureSessionPreset { get set }
    init()
}

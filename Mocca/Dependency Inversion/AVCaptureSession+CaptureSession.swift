//
//  AVCaptureSession+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import Foundation
import AVFoundation

extension AVCaptureSession: CaptureSession {
    
    func canAddInput(_ input: CaptureInput) -> Bool {
        guard let avCaptureInput = input as? AVCaptureInput else {
            assert(false)
            return false
        }
        
        return self.canAddInput(avCaptureInput)
    }
    
    func addInput(_ input: CaptureInput) {
        guard let avCaptureInput = input as? AVCaptureInput else {
            assert(false)
            return
        }
        
        self.addInput(avCaptureInput)
    }
    
    func removeInput(_ input: CaptureInput) {
        
        guard let avCaptureInput = input as? AVCaptureInput else {
            assert(false)
            return
        }
        
        self.removeInput(avCaptureInput)
    }
    
    func canAddOutput(_ output: CaptureOutput) -> Bool {
        guard let avCaptureOutput = output as? AVCaptureOutput else {
            assert(false)
            return false
        }
        
        return self.canAddOutput(avCaptureOutput)
    }
    
    func addOutput(_ output: CaptureOutput) {
        guard let avCaptureOutput = output as? AVCaptureOutput else {
            assert(false)
            return
        }
        
        self.addOutput(avCaptureOutput)
    }
    
    var preset: CaptureSessionPreset {
        get {
            switch self.sessionPreset {
                case .photo:
                    return .photo
                default:
                    fatalError()
            }
        }
        
        set {
            switch newValue {
                case .photo:
                    self.sessionPreset = .photo
                case .unsupported:
                    fatalError()
            }
        }
    }
    
}

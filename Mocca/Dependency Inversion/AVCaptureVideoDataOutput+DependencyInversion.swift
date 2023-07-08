//
//  AVCaptureVideoDataOutput+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation

protocol CaptureVideoOutput: CaptureOutput {
    func setSampleBufferDelegate(_ delegate: CaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue)
}

extension AVCaptureVideoDataOutput: CaptureVideoOutput {
    func setSampleBufferDelegate(_ delegate: CaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        guard let avDelegate = delegate as? AVCaptureVideoDataOutputSampleBufferDelegate else {
            assert(false)
            return
        }
        
        self.setSampleBufferDelegate(avDelegate, queue: queue)
    }
}

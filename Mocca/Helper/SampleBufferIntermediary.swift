//
//  SampleBufferIntermediary.swift
//  Mocca
//
//  Created by David Fearon on 09/02/2023.
//

import Foundation
import AVFoundation

/// Class to receive frame samples, since only subclasses of NSObject can conform to AVCaptureVideoDataOutputSampleBufferDelegate and we'd rather encapsulate that in one place.

class SampleBufferIntermediary: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    init(sampleBufferHandler: SampleBufferHandler) {
        self.sampleBufferHandler = sampleBufferHandler
    }
    
    let sampleBufferHandler: SampleBufferHandler
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.sampleBufferHandler.processSampleBuffer(sampleBuffer)
    }
}

extension SampleBufferIntermediary: CaptureVideoDataOutputSampleBufferDelegate {}

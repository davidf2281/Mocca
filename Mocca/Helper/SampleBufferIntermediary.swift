//
//  SampleBufferIntermediary.swift
//  Mocca
//
//  Created by David Fearon on 09/02/2023.
//

import Foundation
import AVFoundation

/// Class to receive frame samples, since the main Mocca App can't do it as it can't conform to AVCaptureVideoDataOutputSampleBufferDelegate unless it's a subclasses of NSObject, which cause problems.

class SampleBufferIntermediary: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    init(sampleBufferHandler: SampleBufferHandler) {
        self.sampleBufferHandler = sampleBufferHandler
    }
    
    let sampleBufferHandler: SampleBufferHandler
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.sampleBufferHandler.processSampleBuffer(sampleBuffer)
    }
}

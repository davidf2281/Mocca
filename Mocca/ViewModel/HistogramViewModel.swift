//
//  HistogramViewModel.swift
//  Mocca
//
//  Created by David Fearon on 21/10/2020.
//

import Foundation
import AVFoundation

class HistogramViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published private(set) var histogram: Histogram?
    
    private let sampleBufferQueue = DispatchQueue(label: "com.mocca-app.videoSampleBufferQueue")
    private let histogramProcessingQueue = DispatchQueue(label: "com.mocca-app.histogramProcessingQueue")
    private let histogramGenerator: HistogramGenerator?
    private var sampleCount = 0 // Used to limit update rate
    required init(histogramGenerator: HistogramGenerator?, captureManager: CaptureManager?) {
        self.histogramGenerator = histogramGenerator
        super.init()
        captureManager?.setSampleBufferDelegate(self, queue: sampleBufferQueue)
    }
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Reduce system load a little bit by generating a new histogram only every three frames
        sampleCount += 1
        if sampleCount < 3 {
            return
        }
        sampleCount = 0

        histogramProcessingQueue.async {
            let histogram = self.histogramGenerator?.generate(sampleBuffer: sampleBuffer)
            DispatchQueue.main.async {
                self.histogram = histogram
            }
        }
    }
}

//
//  HistogramViewModel.swift
//  Mocca
//
//  Created by David Fearon on 21/10/2020.
//

import Foundation
import AVFoundation

protocol SampleBufferHandler {
    func processSampleBuffer(_ sampleBuffer: CMSampleBufferContract)
}

class HistogramViewModel: NSObject, ObservableObject {
    @Published private(set) var histogram: Histogram?
    
    private let histogramProcessingQueue = DispatchQueue(label: "com.mocca-app.histogramProcessingQueue")
    private let histogramGenerator: HistogramGeneratorContract?
    private var sampleCount = 0 // Used to limit update rate
    
    required init(histogramGenerator: HistogramGeneratorContract?) {
        self.histogramGenerator = histogramGenerator
        super.init()
    }
}

extension HistogramViewModel: SampleBufferHandler {
    func processSampleBuffer(_ sampleBuffer: CMSampleBufferContract) {
        // Reduce system load a little bit by generating a new histogram only every three frames
        sampleCount += 1
        if sampleCount < 3 {
            return
        }
        sampleCount = 0

        histogramProcessingQueue.async { [weak self] in
            let histogram = self?.histogramGenerator?.generate(sampleBuffer: sampleBuffer)
            DispatchQueue.main.async {
                self?.histogram = histogram
            }
        }
    }
}


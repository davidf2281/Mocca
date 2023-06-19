//
//  HistogramViewModel.swift
//  Mocca
//
//  Created by David Fearon on 21/10/2020.
//

import Foundation
import SwiftUI

protocol SampleBufferHandler {
    func processSampleBuffer(_ sampleBuffer: SampleBuffer)
}

struct HistogramBinPath: Identifiable {
    let id: Int
    let path: Path
}

struct HistogramBinPaths {
    let red: [HistogramBinPath]
    let green: [HistogramBinPath]
    let blue: [HistogramBinPath]
}

class HistogramViewModel: NSObject, ObservableObject {
    private(set) var histogram: HistogramContract?
    @Published private(set) var binPaths: HistogramBinPaths?
    
    private let histogramProcessingQueue = DispatchQueue(label: "com.mocca-app.histogramProcessingQueue")
    private let histogramGenerator: HistogramGeneratorContract?
    private var sampleCount = 0
    private let sampleThreshold: Int  // Used to limit update rate
    
    init(histogramGenerator: HistogramGeneratorContract?, processEvery sampleThreshold: Int = 3) {
        self.histogramGenerator = histogramGenerator
        self.sampleThreshold = sampleThreshold
        super.init()
    }
    
    private var redBinPaths: [HistogramBinPath]? {
        guard let histogram else {
            return nil
        }
        return histogram.redBins.map { bin in
            binPath(bin: bin, maxValue: histogram.maxValue)
        }
    }
    
    private var greenBinPaths: [HistogramBinPath]? {
        guard let histogram else {
            return nil
        }
        return histogram.greenBins.map { bin in
            binPath(bin: bin, maxValue: histogram.maxValue)
        }
    }
    
    private var blueBinPaths: [HistogramBinPath]? {
        guard let histogram else {
            return nil
        }
        return histogram.blueBins.map { bin in
            binPath(bin: bin, maxValue: histogram.maxValue)
        }
    }
    
    private func binPath(bin: HistogramBin, maxValue: UInt32) -> HistogramBinPath {
        let path = Path { path in
            path.move(to: CGPoint(x: CGFloat(bin.index), y: 0))
            let normalizedValue = CGFloat(bin.value) / CGFloat(maxValue)
            path.addLine(to: CGPoint(x: CGFloat(bin.index), y: normalizedValue))
        }
        return HistogramBinPath(id: bin.ID, path: path)
    }
    
    private func clip(value: CGFloat, max: CGFloat) -> CGFloat {
        return value > max ? max : value < 0 ? 0 : value
    }
}

extension HistogramViewModel: SampleBufferHandler {
    func processSampleBuffer(_ sampleBuffer: SampleBuffer) {
        // Reduce system load a little bit by generating a new histogram only every three frames
        self.sampleCount += 1
        if self.sampleCount < self.sampleThreshold {
            return
        }
        self.sampleCount = 0
        
        histogramProcessingQueue.async { [weak self] in
            self?.histogram = self?.histogramGenerator?.generate(sampleBuffer: sampleBuffer)

            guard let redBinPaths = self?.redBinPaths,
                  let greenBinPaths = self?.greenBinPaths,
                  let blueBinPaths = self?.blueBinPaths else {
                return
            }

            DispatchQueue.main.async {
                self?.binPaths = HistogramBinPaths(red: redBinPaths, green: greenBinPaths, blue: blueBinPaths)
            }
        }
    }
}


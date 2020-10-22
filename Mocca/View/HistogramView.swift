//
//  HistogramView.swift
//  Mocca
//
//  Created by David Fearon on 21/10/2020.
//

import SwiftUI

enum HistogramViewMode {
    case red
    case green
    case blue
    case all
}

struct HistogramView: View {
    
    @ObservedObject private(set)var viewModel: HistogramViewModel
    
    private let width = CGFloat(64)
    private let height = CGFloat(64)
    private let empiricalMaxValue: CGFloat = 746439
    private let luminanceCorrection: CGFloat = 0.3
    private let mode: HistogramViewMode
    
    init(viewModel: HistogramViewModel, mode:HistogramViewMode) {
        self.mode = mode
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let histogram = viewModel.histogram {
                    
                    if self.mode == .all || self.mode == .blue {
                        ForEach(histogram.blueBins, id: \.ID) { bin in
                            binPath(bin: bin)
                                .stroke(Color.blue)
                        }
                    }
                    
                    if self.mode == .all || self.mode == .green {
                        ForEach(histogram.greenBins, id: \.ID) { bin in
                            binPath(bin: bin)
                                .stroke(Color.green)
                        }
                    }
                    
                    if self.mode == .all || self.mode == .red {
                        ForEach(histogram.redBins, id: \.ID) { bin in
                            binPath(bin: bin)
                                .stroke(Color.red)
                        }
                    }
                    
                }
            }
        }
        
        .frame(width: width, height: height, alignment: .bottom)
        .border(Color(white: 0.5), width: 1)
    }
    
    func binPath(bin: HistogramBin) -> Path {
        return  Path { path in
            path.move(to: CGPoint(x: CGFloat(bin.index), y: height))
            let normalizedValue = CGFloat(bin.value) / empiricalMaxValue
            let luminanceCorrectedValue = pow(normalizedValue, luminanceCorrection)
            path.addLine(to: CGPoint(x: CGFloat(bin.index), y: height - luminanceCorrectedValue * height))
        }
    }
}


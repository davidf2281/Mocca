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
    
    private let width = CGFloat(128)
    private let height = CGFloat(100)
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
                            binPath(bin: bin, maxValue: histogram.maxValue)
                                .stroke(Color.blue)
                        }
                    }
                    
                    if self.mode == .all || self.mode == .green {
                        ForEach(histogram.greenBins, id: \.ID) { bin in
                            binPath(bin: bin, maxValue: histogram.maxValue)
                                .stroke(Color.green)
                        }
                    }

                    if self.mode == .all || self.mode == .red {
                        ForEach(histogram.redBins, id: \.ID) { bin in
                            binPath(bin: bin, maxValue: histogram.maxValue)
                                .stroke(Color.red)
                        }
                    }
                    
                }
            }
        }
        .frame(width: width, height: height, alignment: .bottom)
        .padding(EdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 0))
        .border(Color(white: 0.5), width: 1)
    }
    
    func binPath(bin: HistogramBin, maxValue: UInt32) -> Path {
        return  Path { path in
            path.move(to: CGPoint(x: CGFloat(bin.index), y: height))
            let normalizedValue = CGFloat(bin.value) / CGFloat(maxValue)
            let amplifiedValue = clip(value: normalizedValue * height * 25, max: height)
            path.addLine(to: CGPoint(x: CGFloat(bin.index), y: height - amplifiedValue))
        }
    }
    
    func clip(value: CGFloat, max: CGFloat) -> CGFloat {
        return value > max ? max : value < 0 ? 0 : value
    }
}

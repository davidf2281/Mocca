//
//  HistogramView.swift
//  Mocca
//
//  Created by David Fearon on 21/10/2020.
//

import SwiftUI

struct HistogramView: View {
    
    private let width = CGFloat(128)
    private let height = CGFloat(64)
    @ObservedObject var viewModel: HistogramViewModel
    private let empiricalMaxValue: CGFloat = 746439
    private let luminanceCorrection: CGFloat = 0.3
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let histogram = viewModel.histogram {
                    ForEach(histogram.blueBins, id: \.ID) { bin in
                        Path { path in
                            path.move(to: CGPoint(x: CGFloat(bin.index), y: height))
                            let normalizedValue = CGFloat(bin.value) / empiricalMaxValue
                            let luminanceCorrectedValue = pow(normalizedValue, luminanceCorrection)
                            path.addLine(to: CGPoint(x: CGFloat(bin.index), y: height - luminanceCorrectedValue * height))
                        }
                        .stroke(Color.blue)
                    }

                    ForEach(histogram.greenBins, id: \.ID) { bin in
                        Path { path in
                            path.move(to: CGPoint(x: CGFloat(bin.index), y: height))
                            let normalizedValue = CGFloat(bin.value) / empiricalMaxValue
                            let luminanceCorrectedValue = pow(normalizedValue, luminanceCorrection)
                            path.addLine(to: CGPoint(x: CGFloat(bin.index), y: height - luminanceCorrectedValue * height))
                        }
                        .stroke(Color.green)
                    }
                    
                    ForEach(histogram.redBins, id: \.ID) { bin in
                        Path { path in
                            path.move(to: CGPoint(x: CGFloat(bin.index), y: height))
                            let normalizedValue = CGFloat(bin.value) / empiricalMaxValue
                            let luminanceCorrectedValue = pow(normalizedValue, luminanceCorrection)
                            path.addLine(to: CGPoint(x: CGFloat(bin.index), y: height - luminanceCorrectedValue * height))
                        }
                        .stroke(Color.red)
                    }
                }
            }
        }
        .frame(width: width, height: height, alignment: .bottom)
        .border(Color(white: 0.5), width: 1)
    }
}


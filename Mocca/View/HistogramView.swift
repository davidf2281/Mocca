//
//  HistogramView.swift
//  Mocca
//
//  Created by David Fearon on 21/10/2020.
//

import SwiftUI

struct HistogramView<Model>: View where Model: HistogramViewModel {
    
    private let width = CGFloat(128)
    private let height = CGFloat(64)
    
    @ObservedObject var viewModel: Model
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let histogram = viewModel.histogram {
                    ForEach(histogram.greenBins, id: \.indexForID) { bin in
                        Path { path in
                            path.move(to: CGPoint(x: CGFloat(bin.indexForID), y: height))
                            path.addLine(to: CGPoint(x: CGFloat(bin.indexForID), y: height - CGFloat(bin.value / 4)))
                        }
                        .stroke(Color.green)
                    }
                }
            }
        }
        .frame(width: width, height: height, alignment: .bottom)
        .border(Color(white: 0.5), width: 1)
    }
}


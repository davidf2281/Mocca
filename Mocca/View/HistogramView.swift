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
                if let redPaths = viewModel.binPaths?.red,
                   let greenPaths = viewModel.binPaths?.green,
                   let bluePaths = viewModel.binPaths?.blue {
                    
                    if self.mode == .all || self.mode == .red {
                        ForEach(redPaths, id: \.id) { binPath in
                            binPath.path
                                .stroke(Color.red)
                                .scaleEffect(y: geometry.size.height, anchor: .top)
                                .scaleEffect(y: -1)
                        }
                    }
                    
                    if self.mode == .all || self.mode == .green {
                        ForEach(greenPaths, id: \.id) { binPath in
                            binPath.path
                                .stroke(Color.green)
                                .scaleEffect(y: geometry.size.height, anchor: .top)
                                .scaleEffect(y: -1)
                        }
                    }
                    
                    if self.mode == .all || self.mode == .blue {
                        ForEach(bluePaths, id: \.id) { binPath in
                            binPath.path
                                .stroke(Color.blue)
                                .scaleEffect(y: geometry.size.height, anchor: .top)
                                .scaleEffect(y: -1)
                        }
                    }
                }
            }
        }
        .frame(width: width, height: height, alignment: .bottom)
        .padding(EdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 0))
        .border(Color(white: 0.5), width: 1)
    }
}

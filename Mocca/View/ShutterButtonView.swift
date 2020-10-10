//
//  ShutterButtonView.swift
//  Mocca
//
//  Created by David Fearon on 04/10/2020.
//

import SwiftUI

struct ShutterButtonView: View {
    
    @ObservedObject var viewModel: ShutterButtonViewModel
    
    private let continuousAnimation = Animation.linear(duration: 2).repeatForever(autoreverses: false)
    private let solidStroke = StrokeStyle( lineWidth: 3)
    private let dashedStroke = StrokeStyle( lineWidth: 3, dash: [10] )
    
    var body: some View {
        ZStack {
            Circle().stroke(Color.gray, style: viewModel.state == .ready ? solidStroke : dashedStroke)
                .frame(width: 65, height: 65, alignment: .center)
                .rotation3DEffect(
                    viewModel.state != .ready ? Angle(degrees: 360) : Angle(degrees: 0), axis: (x: 0.0, y: 0.0, z: 1.0), perspective: 0
                )
                .animation(viewModel.state != .ready ? continuousAnimation : .easeIn(duration: 0))
            Circle().fill(viewModel.state == .ready ? Color.red : Color.gray)
                .frame(width: 50, height: 50, alignment: .center)
        }.onTapGesture(count: 1, perform: {
            self.viewModel.tapped()
        }).disabled(viewModel.state != .ready)
    }
}

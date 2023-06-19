//
//  WidgetView.swift
//  Mocca
//
//  Created by David Fearon on 27/09/2020.
//

import SwiftUI
import CoreGraphics


/// A reticle-style view to indicate current focus/exposure point.
struct WidgetView: View {
    
    private let reticleRadius: CGFloat = 25
    
    @EnvironmentObject var orientationPublisher: OrientationPublisher
    @ObservedObject var viewModel: WidgetViewModel
    
    var body: some View {
        GeometryReader { parent in
            VStack(alignment: .center, spacing: 2, content: {
                Circle().stroke(Color.blue, style: StrokeStyle( lineWidth: 3, dash: [10]))
                    .frame(width: reticleRadius * 2, height: reticleRadius * 2, alignment: .center)
            })
            .contentShape(Rectangle())
            .position(ViewConversion.clamp(position: ViewConversion.displayPosition(position: self.viewModel.position, orientation: orientationPublisher.interfaceOrientation, parentFrame: parent.size), frame: parent.size, inset: reticleRadius))
            .animation(.easeOut(duration: 0.2), value: viewModel.position)
        }.accessibility(label: Text("reticle"))
    }
}

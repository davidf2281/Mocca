//
//  SimulatorPreview.swift
//  Mocca
//
//  Created by David Fearon on 05/10/2020.
//

import SwiftUI

struct SimulatorPreview: View {
    var body: some View {
        GeometryReader(content: { geometry in
            Image("simulator_preview").resizable().aspectRatio(contentMode: .fit)
                .opacity(0.4)
                .overlay(Text("Running on Simulator:\nno camera preview.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 30, weight: .semibold, design: .default))
                            .foregroundColor(Color(red: 1.0, green: 1.0, blue: 0.9, opacity: 0.4))
                            .offset(x: 0, y: 75))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }).background(Color.black)
    }
}

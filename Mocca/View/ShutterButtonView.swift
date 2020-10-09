//
//  ShutterButtonView.swift
//  Mocca
//
//  Created by David Fearon on 04/10/2020.
//

import SwiftUI

struct ShutterButtonView: View {
    
    @ObservedObject var viewModel: ShutterButtonViewModel
    
    var body: some View {
        Button(action: {
            viewModel.tapped()
        }) {
            ZStack {
                Circle().stroke(Color.gray, lineWidth: 3)
                    .frame(width: 65, height: 65, alignment: .center)
            Circle().fill(viewModel.state == .ready ? Color.red : Color.gray)
                .frame(width: 50, height: 50, alignment: .center)
            }
        }.disabled(viewModel.state != .ready)
    }
}

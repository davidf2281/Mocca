//
//  AvailableCameraButtonView.swift
//  Mocca
//
//  Created by David Fearon on 31/10/2020.
//

import SwiftUI
import AVFoundation
struct AvailableCameraButtonView: View {
    
    @ObservedObject var viewModel: AvailableCameraButtonViewModel
    
    var body: some View {
//        let fovString = String(format: "%.0fº", viewModel.fov)

        let displayString = viewModel.position == .back ? viewModel.cameraTypeDisplayString() : "front"
        ZStack {
            Text(displayString).foregroundColor(viewModel.selected ? Color.white : Color.gray)
                .font(.system(size: 14))
                .padding(6)
                .frame(minWidth: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.selected ? Color.white : Color.gray, lineWidth: viewModel.selected ? 2 : 1)
                        )
               
        }
        .onTapGesture {
            self.viewModel.tapped()
        }
    }
}

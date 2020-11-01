//
//  AvailableCameraButtonView.swift
//  Mocca
//
//  Created by David Fearon on 31/10/2020.
//

import SwiftUI

struct AvailableCameraButtonView: View {
    
    @ObservedObject var viewModel: AvailableCameraButtonViewModel
    
    var body: some View {
        let fovString = String(format: "%.0fº", viewModel.fov)
        ZStack {
            Text(fovString).foregroundColor(viewModel.selected ? Color.white : Color.gray)
            Circle().stroke(viewModel.selected ? Color.white : Color.gray, style: StrokeStyle( lineWidth: viewModel.selected ? 2 : 1 ))
                .frame(width: 40, height: 40, alignment: .center)
        }
        .padding(EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 10))
        .onTapGesture {
            self.viewModel.tapped()
        }
    }
}

//
//  AvailableCameraButtonsView.swift
//  Mocca
//
//  Created by David Fearon on 31/10/2020.
//

import SwiftUI

struct AvailableCameraButtonsView: View {
    
    let viewModels: [AvailableCameraButtonViewModel]
    
    var body: some View {
        HStack{
            ForEach(viewModels, id: \.ID) { cameraViewModel in
                AvailableCameraButtonView(viewModel: cameraViewModel)
            }
        }
    }
}

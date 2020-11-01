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
            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))

        }
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
    }
}

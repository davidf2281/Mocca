//
//  CameraErrorView.swift
//  Mocca
//
//  Created by David Fearon on 28/09/2020.
//

import SwiftUI

struct CameraErrorView: View {
    
    let viewModel: CameraErrorViewModel
    
    init(viewModel: CameraErrorViewModel) {
        self.viewModel = viewModel
    }
            
    var body: some View {

        Text(viewModel.displayText)
            .font(.system(size: 17))
            .fontWeight(.semibold)
            .lineSpacing(7)
            .foregroundColor(viewModel.textColor).multilineTextAlignment(.center)
            .frame(maxWidth:275, maxHeight: .infinity)
            .offset(x: 0, y: -75)
    }
}

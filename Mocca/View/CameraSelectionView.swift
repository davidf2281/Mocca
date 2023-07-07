//
//  CameraSelectionView.swift
//  Mocca
//
//  Created by David Fearon on 07/07/2023.
//

import SwiftUI

struct CameraSelectionView: View {
    
    @ObservedObject private(set) var viewModel: CameraSelectionViewModel
    
    init?(viewModel: CameraSelectionViewModel?) {
        
        guard let viewModel else {
            return nil
        }
        
        self.viewModel = viewModel
    }
            
    var body: some View {
        VStack {
            Picker("Camera selector", selection: $viewModel.selectedCameraViewModel) {
                ForEach(viewModel.selectableCameraViewModels) {
                    Text($0.displayName).tag($0)
                }
            }
        }
    }
}

//
//  CameraSelectionViewModel.swift
//  Mocca
//
//  Created by David Fearon on 07/07/2023.
//

import Foundation
import Combine

class CameraSelectionViewModel: ObservableObject {
    
    @Published var selectedCameraViewModel: SelectableCameraViewModel
    private(set) var selectableCameraViewModels: [SelectableCameraViewModel]
    private var cancellables = Set<AnyCancellable>()
    private let model: CameraSelection
    
    init(model: CameraSelection) {
        self.model = model
        
        let selectableCameraViewModels = model.availableCameras.map { SelectableCameraViewModel(model: $0) }
        self.selectableCameraViewModels = selectableCameraViewModels
        self.selectedCameraViewModel = selectableCameraViewModels.first(where: { $0 == SelectableCameraViewModel(model: model.selectedCamera) } )! // TODO: Address force-unwrapped optional
        
        self.model.selectedCameraPublisher.sink(receiveValue: { [weak self] selectedCamera in
            self?.selectedCameraViewModel = selectableCameraViewModels.first(where: { $0 == SelectableCameraViewModel(model: model.selectedCamera) } )! // TODO: Address force-unwrapped optional
        }).store(in: &cancellables)
        
        $selectedCameraViewModel.sink { [weak self] selectedCamera in
            print("Selected: \(selectedCamera.displayName)")
            self?.model.selectCamera(cameraID: selectedCamera.id)
        }.store(in: &cancellables)
    }
}

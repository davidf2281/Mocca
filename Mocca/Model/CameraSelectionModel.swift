//
//  AvailableCamerasModel.swift
//  Mocca
//
//  Created by David Fearon on 06/07/2023.
//

import Foundation
import Combine

protocol CameraSelection: AnyObject {
    var availableCameras: [PhysicalCamera] { get }
    var selectedCamera: PhysicalCamera { get }
    var selectedCameraPublisher: Published<PhysicalCamera>.Publisher { get }
    func selectCamera(cameraID: UUID)
}

class CameraSelectionModel: CameraSelection, ObservableObject {

    @Published fileprivate(set) var selectedCamera: PhysicalCamera
    var selectedCameraPublisher: Published<PhysicalCamera>.Publisher { $selectedCamera }

    private(set) var availableCameras: [PhysicalCamera]
    private let sessionManager: SessionManagerContract
    private var cancellables = Set<AnyCancellable>()
    
    init?(availableCameras: [PhysicalCamera], sessionManager: SessionManagerContract?) {
        
        guard let sessionManager else {
            return nil
        }
        
        self.availableCameras = availableCameras
        self.sessionManager = sessionManager
        self.selectedCamera = sessionManager.activeCamera
    }
    
    func selectCamera(cameraID: UUID) {
        let result = self.sessionManager.selectCamera(cameraID: cameraID)
        
        switch result {
            case .success(let physicalCamera):
                self.selectedCamera = physicalCamera
            case .failure(_):
                assert(false)
        }
    }
}

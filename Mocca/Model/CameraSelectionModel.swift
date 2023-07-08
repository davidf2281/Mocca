//
//  AvailableCamerasModel.swift
//  Mocca
//
//  Created by David Fearon on 06/07/2023.
//

import Foundation

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
    
    init?(availableCameras: [PhysicalCamera], sessionManager: SessionManagerContract?) {
        
        guard let sessionManager else {
            return nil
        }
        
        self.availableCameras = availableCameras
        self.sessionManager = sessionManager
        self.selectedCamera = sessionManager.activeCamera
    }
    
    func selectCamera(cameraID: UUID) {
        _ = self.sessionManager.selectCamera(cameraID: cameraID)
    }
}

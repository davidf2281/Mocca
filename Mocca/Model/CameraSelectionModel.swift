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
    private let captureManager: CaptureManagerContract
    
    init?(availableCameras: [PhysicalCamera], captureManager: CaptureManagerContract?) {
        
        guard let captureManager else {
            return nil
        }
        
        self.availableCameras = availableCameras
        self.captureManager = captureManager
        self.selectedCamera = captureManager.activeCamera
    }
    
    func selectCamera(cameraID: UUID) {
        _ = self.captureManager.selectCamera(cameraID: cameraID)
    }
}

//
//  AvailableCamerasModel.swift
//  Mocca
//
//  Created by David Fearon on 06/07/2023.
//

import Foundation

protocol CameraSelection: AnyObject {
    var availableCameras: [LogicalCameraDevice] { get }
    var selectedCamera: LogicalCameraDevice? { get }
    var selectedCameraPublisher: Published<LogicalCameraDevice?>.Publisher { get }
    func selectCamera(_ camera: LogicalCameraDevice)
}

class CameraSelectionModel: CameraSelection {

    @Published fileprivate(set) var selectedCamera: LogicalCameraDevice?
    var selectedCameraPublisher: Published<LogicalCameraDevice?>.Publisher { $selectedCamera }

    private(set) var availableCameras: [LogicalCameraDevice]
    private let captureManager: CaptureManagerContract
    
    init(availableCameras: [LogicalCameraDevice], captureManager: CaptureManagerContract) {
        self.availableCameras = availableCameras
        self.captureManager = captureManager
        
        // TODO: Remove this test code
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            self.captureManager.selectCamera(type: LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back))
        }
    }
    
    func selectCamera(_ camera: LogicalCameraDevice) {
        let result = self.captureManager.selectCamera(type: camera)
        
        switch result {
            case .success():
                break
            case .failure(_):
                assert(false)
        }
    }
}

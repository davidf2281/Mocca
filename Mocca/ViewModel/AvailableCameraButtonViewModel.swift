//
//  AvailableCameraButtonViewModel.swift
//  Mocca
//
//  Created by David Fearon on 31/10/2020.
//

import Foundation

protocol AvailableCameraButtonViewModelProtocol: ObservableObject {
    var fov: FOV { get }
    var selected: Bool { get }
    func tapped()
}

class AvailableCameraButtonViewModel: AvailableCameraButtonViewModelProtocol {
    
    @Published private(set) var selected: Bool

    var fov: FOV {
        return self.camera.fov
    }
    
    let ID = UUID()
    
    func tapped() {
        do {
            try self.captureManager?.setActiveCaptureDevice(self.camera.captureDevice)
        } catch {
            // MARK: TODO: Error UI?
        }
    }
    
    private let captureManager: CaptureManager?
    private let camera: AvailableCamera
    
    required init(selected: Bool, camera:AvailableCamera, captureManager: CaptureManager?) {
        self.selected = selected
        self.camera = camera
        self.captureManager = captureManager
    }
}

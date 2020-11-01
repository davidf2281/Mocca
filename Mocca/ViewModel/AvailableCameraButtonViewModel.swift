//
//  AvailableCameraButtonViewModel.swift
//  Mocca
//
//  Created by David Fearon on 31/10/2020.
//

import Foundation
import Combine
import AVFoundation

protocol AvailableCameraButtonViewModelProtocol {
    var fov: FOV { get }
    var selected: Bool { get }
    func tapped()
}

class AvailableCameraButtonViewModel: AvailableCameraButtonViewModelProtocol, ObservableObject {
    
    @Published private(set) var selected: Bool
    
    var position: AVCaptureDevice.Position {
        return self.camera.position
    }
    
    var type:AVCaptureDevice.DeviceType {
        return self.camera.type
    }
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func cameraTypeDisplayString() -> String {
        switch self.type {
        case .builtInTelephotoCamera:
            return "tele"
        case .builtInWideAngleCamera:
            return "wide"
        case .builtInUltraWideCamera:
            return "ultrawide"
        default:
            return "other"
        }
    }
    
    private let captureManager: DeviceCaptureManager?
    private let camera: AvailableCamera
    
    required init(selected: Bool, camera:AvailableCamera, captureManager: DeviceCaptureManager?) {
        self.selected = selected
        self.camera = camera
        self.captureManager = captureManager
        // Bind model's activeCaptureDevice to our selected state
        captureManager?.$activeCaptureDevice
            .map( { $0 as! AVCaptureDevice } )
            .sink(receiveValue: { (device) in
                self.selected = ( device === self.camera.captureDevice )
            })
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

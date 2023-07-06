//
//  ExposureBiasViewModel.swift
//  Mocca
//
//  Created by David Fearon on 24/10/2020.
//

import Foundation

typealias EV = Float

protocol ExposureBiasViewModelProtocol: ObservableObject {
    var compensation: EV { get }
    func dragged(extent:CGFloat)
    func dragEnded()
}

class ExposureBiasViewModel: ExposureBiasViewModelProtocol {
    
    @Published private(set) var compensation: EV = 0
    
    private let captureManager: CaptureManagerContract?
    
    private var compensationAtDragStart:EV = 0
    private var dragStarted = false
    private let cameraOperation: CameraOperationContract
    
    required init(captureManager: CaptureManagerContract?, cameraOperation: CameraOperationContract = CameraOperation()) {
        self.captureManager = captureManager
        self.cameraOperation = cameraOperation
    }
    
    func dragged(extent:CGFloat) {
        
        if !self.dragStarted {
            self.compensationAtDragStart = self.compensation
            self.dragStarted = true
        }
        
        let newComp = self.compensationAtDragStart + EV(extent / 100)
        
        if let device = self.captureManager?.activeCaptureDevice {
            
            if (cameraOperation.canSetExposureTargetBias(ev: newComp, for: device)) {
                if cameraOperation.willTargetBiasHaveEffect(ev: newComp, for: device){
                    do {
                        _ = try cameraOperation.setExposureTargetBias(ev: self.compensation, for: device, completion: nil)
                        self.compensation = newComp
                    } catch {
                        // MARK: TODO: UI error feedback
                    }
                }
            }
        }
    }
    
    func dragEnded() {
        self.dragStarted = false
    }
}

//
//  ExposureBiasViewModel.swift
//  Mocca
//
//  Created by David Fearon on 24/10/2020.
//

import Foundation

typealias EV = Float

protocol ExposureBiasViewModelContract: ObservableObject {
    var compensation: EV { get }
    func dragged(extent:CGFloat)
    func dragEnded()
}

class ExposureBiasViewModel: ExposureBiasViewModelContract {
    
    @Published private(set) var compensation: EV = 0
    
    private let sessionManager: SessionManagerContract?
    
    private var compensationAtDragStart:EV = 0
    private var dragStarted = false
    private let cameraOperation: CameraOperationContract
    
    required init(sessionManager: SessionManagerContract?, cameraOperation: CameraOperationContract = CameraOperation()) {
        self.sessionManager = sessionManager
        self.cameraOperation = cameraOperation
    }
    
    func dragged(extent:CGFloat) {
        
        if !self.dragStarted {
            self.compensationAtDragStart = self.compensation
            self.dragStarted = true
        }
        
        let newComp = self.compensationAtDragStart + EV(extent / 100)
        
        if let device = self.sessionManager?.activeCaptureDevice,
           cameraOperation.canSetExposureTargetBias(ev: newComp, for: device),
           cameraOperation.willTargetBiasHaveEffect(ev: newComp, for: device)
        {
            do {
                _ = try cameraOperation.setExposureTargetBias(ev: self.compensation, for: device, completion: nil)
                self.compensation = newComp
            } catch {
                // MARK: TODO: UI error feedback
            }
        }
    }
    
    func dragEnded() {
        self.dragStarted = false
    }
}

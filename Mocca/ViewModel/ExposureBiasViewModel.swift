//
//  ExposureBiasViewModel.swift
//  Mocca
//
//  Created by David Fearon on 24/10/2020.
//

import Foundation
import AVFoundation

typealias EV = Float

protocol ExposureBiasViewModelProtocol: ObservableObject {
    var compensation: EV { get }
    func dragged(extent:CGFloat)
    func dragEnded()
}

class ExposureBiasViewModel: ExposureBiasViewModelProtocol {
    
    @Published private(set) var compensation: EV = 0
    
    private let captureManager: CaptureManager?
    
    private var compensationAtDragStart:EV = 0
    private var dragStarted = false
    
    required init(captureManager: CaptureManager?) {
        self.captureManager = captureManager
    }
    
    func dragged(extent:CGFloat) {
        
        if !self.dragStarted {
            self.compensationAtDragStart = self.compensation
            self.dragStarted = true
        }
        
        self.compensation = self.compensationAtDragStart + EV(extent / 100)
        print("comp: \(self.compensation)")
        if let device = self.captureManager?.activeCaptureDevice {
            do {
            _ = try CameraOperation.setExposureTargetBias(ev: self.compensation, for: device, completion: { time in })
            } catch {
                // MARK: TODO: UI error feedback
            }
        }
    }
    
    func dragEnded() {
        self.dragStarted = false
    }
}

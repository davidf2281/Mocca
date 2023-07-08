//
//  WidgetViewModel.swift
//  Mocca
//
//  Created by David Fearon on 01/10/2020.
//

import Foundation
import CoreGraphics

class WidgetViewModel: ObservableObject {
    
    private let sessionManager: SessionManagerContract?
    @Published var position: CGPoint
    
    private(set) var dockedPosition: CGPoint
    private let cameraOperation: CameraOperationContract

    var displayCharacter : String {
        willSet {
            assert(newValue.count == 1, "Display string must be exactly one character in length")
        }
    }
    
    func dragEnded(position:CGPoint, frameSize:CGSize) {
        if let device = self.sessionManager?.activeCaptureDevice,
           let layer = self.sessionManager?.videoPreviewLayer {
            _ = cameraOperation.setFocusPointOfInterest(position, on: layer, for: device)
            _ = cameraOperation.setExposurePointOfInterest(position, on: layer, for: device)
        }
    }
    
    required init(sessionManager: SessionManagerContract?, dockedPosition: CGPoint, displayCharacter: String, cameraOperation: CameraOperationContract = CameraOperation()) {
        self.sessionManager = sessionManager
        self.dockedPosition = dockedPosition
        self.position = dockedPosition
        self.displayCharacter = displayCharacter
        self.cameraOperation = cameraOperation
    }
}

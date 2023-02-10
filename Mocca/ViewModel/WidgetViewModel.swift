//
//  WidgetViewModel.swift
//  Mocca
//
//  Created by David Fearon on 01/10/2020.
//

import Foundation
import CoreGraphics

class WidgetViewModel: ObservableObject {
    
    private let captureManager: CaptureManager?
    @Published public var position: CGPoint
    
    private(set) var dockedPosition: CGPoint
    private let cameraOperation: CameraOperationContract

    var displayCharacter : String {
        willSet {
            assert(newValue.count == 1, "Display string must be exactly one character in length")
        }
    }
    
    func dragEnded(position:CGPoint, frameSize:CGSize) {
        if let device = self.captureManager?.activeCaptureDevice,
           let layer = self.captureManager?.videoPreviewLayer {
            _ = cameraOperation.setFocusPointOfInterest(position, on: layer, for: device)
            _ = cameraOperation.setExposurePointOfInterest(position, on: layer, for: device)
        }
    }
    
    required init(captureManager: CaptureManager?, dockedPosition: CGPoint, displayCharacter: String, cameraOperation: CameraOperationContract = CameraOperation()) {
        self.captureManager = captureManager
        self.dockedPosition = dockedPosition
        self.position = dockedPosition
        self.displayCharacter = displayCharacter
        self.cameraOperation = cameraOperation
    }
}

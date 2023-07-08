//
//  PreviewViewModel.swift
//  Mocca
//
//  Created by David Fearon on 02/10/2020.
//

import Foundation
import CoreGraphics

class PreviewViewModel: ObservableObject {
    
    private let sessionManager: SessionManagerContract?

    // MARK: TODO:
    // Update aspect ratio dynamically from SessionManager's currentOutputAspectRatio() function
    // to account for the possibility that future devices could have non-4:3 cameras or multiple cameras with
    // varying aspect ratios
    /// The aspect ratio of the preview's video capture layer
    @Published private(set) var aspectRatio: CGFloat = 0.75
    private let cameraOperation: CameraOperationContract

    required init(sessionManager: SessionManagerContract?, cameraOperation: CameraOperationContract = CameraOperation()) {
        self.sessionManager = sessionManager
        self.cameraOperation = cameraOperation
    }
    
    func tapped(position:CGPoint, frameSize:CGSize) {
        if let device = self.sessionManager?.activeCaptureDevice,
           let layer = self.sessionManager?.videoPreviewLayer {
            _ = cameraOperation.setFocusPointOfInterest(position, on: layer, for: device)
            _ = cameraOperation.setExposurePointOfInterest(position, on: layer, for: device)
        }
    }
}

//
//  PreviewViewModel.swift
//  Mocca
//
//  Created by David Fearon on 02/10/2020.
//

import Foundation
import CoreGraphics

class PreviewViewModel: ObservableObject {
    
    private let captureManager: CaptureManager?

    // MARK: TODO:
    // Update aspect ratio dynamically from CaptureManager's currentOutputAspectRatio() function
    // to account for the possibility that future devices could have non-4:3 cameras or multiple cameras with
    // varying aspect ratios
    
    /// The aspect ratio of the preview's video capture layer
    @Published private(set) var aspectRatio: CGFloat = 0.75
    
    required init(captureManager: CaptureManager?) {
        self.captureManager = captureManager
    }
    
    func tapped(position:CGPoint, frameSize:CGSize) {
        if var device = self.captureManager?.activeCaptureDevice,
           let layer = self.captureManager?.videoPreviewLayer {
            _ = CameraOperation.setFocusPointOfInterest(position, on: layer, for: &device)
            _ = CameraOperation.setExposurePointOfInterest(position, on: layer, for: &device)
        }
    }
}

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
    
    var displayCharacter : String {
        willSet {
            assert(newValue.count == 1, "Display string must be exactly one character in length")
        }
    }
    
    func dragEnded(position:CGPoint, frameSize:CGSize) {
        if let manager = self.captureManager {
            _ = manager.setExposurePointOfInterest(position)
            _ = manager.setFocusPointOfInterest(position)
        }
    }
    
    required init(captureManager: CaptureManager?, dockedPosition: CGPoint, displayCharacter: String) {
        self.captureManager = captureManager
        self.dockedPosition = dockedPosition
        self.position = dockedPosition
        self.displayCharacter = displayCharacter
    }
}

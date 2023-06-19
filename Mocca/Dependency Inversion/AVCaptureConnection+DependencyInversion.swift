//
//  AVCaptureConnection+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation
import UIKit

extension AVCaptureConnection: CaptureConnection {
    var orientation: UIInterfaceOrientation {
        get {
            Orientation.uiInterfaceOrientation(for: self.videoOrientation)
        }
        set {
            self.videoOrientation = Orientation.avOrientation(for: Orientation.currentInterfaceOrientation())
        }
    }
}

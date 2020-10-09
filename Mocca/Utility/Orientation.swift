//
//  Orientation.swift
//  Mocca
//
//  Created by David Fearon on 30/09/2020.
//

import Foundation
import UIKit
import AVFoundation

struct Orientation {
    
    /// Utility function to find the device's orientation
    /// - Returns: Current interface orientation, defaulting to .portrait if current orientation is not available
    public static func currentInterfaceOrientation() -> UIInterfaceOrientation {
        if let orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
            return orientation
        }
        return .portrait
    }
  
    /// Translates a UIInterfaceOrientation enum into its AVCaptureVideoOrientation equivalent
    /// - Parameter UIOrientation: The orientation to translate
    /// - Returns: The equivalent AVCaptureVideoOrientation
    public static func AVOrientation(for UIOrientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch UIOrientation {
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
}

/// SwiftUI fails to notify subscribers of changes to published properties on UIViewController subclasses,
/// so implementing an orientation property directly on a viewcontroller for observation by SwiftUI views does not work.
/// This wrapper class is a workaround.
class OrientationPublisher: ObservableObject {
    @Published var interfaceOrientation: UIInterfaceOrientation = .portrait
}

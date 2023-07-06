//
//  Orientation.swift
//  Mocca
//
//  Created by David Fearon on 30/09/2020.
//

import Foundation
import UIKit
import AVFoundation

protocol OrientationContract {
    static func currentInterfaceOrientation() -> UIInterfaceOrientation
    static func avOrientation(for uiOrientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation
    static func uiInterfaceOrientation(for avOrientation: AVCaptureVideoOrientation) -> UIInterfaceOrientation
}

struct Orientation: OrientationContract {
    
    /// Utility function to find the device's orientation
    /// - Returns: Current interface orientation, defaulting to .portrait if current orientation is not available
    static func currentInterfaceOrientation() -> UIInterfaceOrientation {

        // CREDIT: adapted from stackoverflow.com/a/68989580/2201154
        if let orientation = UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap ({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)?
            .windowScene?
            .interfaceOrientation
        {
            return orientation
        }
        return .portrait
    }
    
    /// Translates a UIInterfaceOrientation enum into its AVCaptureVideoOrientation equivalent
    /// - Parameter UIOrientation: The orientation to translate
    /// - Returns: The equivalent AVCaptureVideoOrientation
    static func avOrientation(for uiOrientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch uiOrientation {
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
    
    static func uiInterfaceOrientation(for avOrientation: AVCaptureVideoOrientation) -> UIInterfaceOrientation {
        switch avOrientation {
                
            case .portrait:
                return .portrait
            case .portraitUpsideDown:
                return .portraitUpsideDown
            case .landscapeRight:
                return .landscapeRight
            case .landscapeLeft:
                return .landscapeLeft
            @unknown default:
                assert(false)
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

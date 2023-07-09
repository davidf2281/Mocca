//
//  CaptureVideoPreviewLayer.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation
import UIKit

protocol CaptureConnection: AnyObject {
    var orientation: UIInterfaceOrientation { get set }
}

enum LayerGravity {
    case resize
    case resizeAspect
    case resizeAspectFill
}

protocol CaptureVideoPreviewLayer: AnyObject {
    func captureDevicePointConverted(fromLayerPoint pointInLayer: CGPoint) -> CGPoint
    var frame: CGRect { get set }
    var captureConnection: CaptureConnection? { get }
    var captureSession: CaptureSession? { get set }
    var gravity: LayerGravity { get set }
}

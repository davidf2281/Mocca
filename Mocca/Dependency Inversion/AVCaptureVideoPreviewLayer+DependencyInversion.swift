//
//  AVCaptureVideoPreviewLayer+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation
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

class DeviceCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayer, CaptureVideoPreviewLayer {
    
    var captureSession: CaptureSession? {
        get {
            return self.session
        }
        set {
            self.session = newValue as? AVCaptureSession
        }
    }
    
    var gravity: LayerGravity {
        get {
            switch self.videoGravity {
                case .resize:
                    return .resize
                case .resizeAspect:
                    return .resizeAspect
                case .resizeAspectFill:
                    return .resizeAspectFill
                default:
                    assert(false)
                    return .resize
            }
        }
        
        set {
            switch newValue {
                case .resize:
                    self.videoGravity = .resize
                case .resizeAspect:
                    self.videoGravity = .resizeAspect
                case .resizeAspectFill:
                    self.videoGravity = .resizeAspectFill
            }
        }
    }
    
    var captureConnection: CaptureConnection? {
        return self.connection
    }
}

//
//  File.swift
//  Mocca
//
//  Created by David Fearon on 25/09/2020.
//

import UIKit
import AVFoundation
import SwiftUI

final class PreviewUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use initWithFrame:")
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}

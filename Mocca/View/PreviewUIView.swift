//
//  File.swift
//  Mocca
//
//  Created by David Fearon on 25/09/2020.
//

import UIKit

final class PreviewUIView: UIView {
        
    required init(viewModel: PreviewUIViewModel) {
        super.init(frame: .zero)
        self.backgroundColor = viewModel.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var videoPreviewLayer: CaptureVideoPreviewLayer? {
        return self.layer as? CaptureVideoPreviewLayer
    }
    
    override class var layerClass: AnyClass {
        return DeviceCaptureVideoPreviewLayer.self
    }
}

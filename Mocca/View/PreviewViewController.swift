//
//  PreviewViewController.swift
//  Mocca
//
//  Created by David Fearon on 25/09/2020.
//

import UIKit
import AVFoundation
import SwiftUI

final class PreviewViewController: UIViewController {
    
    private let previewView: PreviewUIView?
    
    private(set) public var orientationPublisher : OrientationPublisher

    required init?(coder: NSCoder) {
        fatalError("Use initWithPreviewView: orientationPublisher:")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Use initWithPreviewView: orientationPublisher:")
    }
    
    required init(previewView: PreviewUIView?, orientationPublisher: OrientationPublisher) {
        self.previewView = previewView
        self.orientationPublisher = orientationPublisher
        super.init(nibName: nil, bundle: nil)
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        // TODO: Publishing interface orientation here generates runtime warning "Publishing changes from within view updates is not allowed". Figure out why we ever had this line here since it appears to make no difference when commented out
        // self.orientationPublisher.interfaceOrientation = Orientation.currentInterfaceOrientation()
        self.view.backgroundColor = UIColor.black
        if let preview = self.previewView {
            preview.frame = self.view.frame
            self.view.addSubview(preview)
        }
    }

    override func viewDidLayoutSubviews() {
        if let preview = self.previewView {
            preview.videoPreviewLayer.frame = self.view.frame
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            
            self.orientationPublisher.interfaceOrientation = Orientation.currentInterfaceOrientation()
            self.previewView?.videoPreviewLayer.connection?.videoOrientation = Orientation.AVOrientation(for: self.orientationPublisher.interfaceOrientation)
            
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
}

struct PreviewViewControllerRepresentable: UIViewControllerRepresentable {
    
    public typealias UIViewControllerType = PreviewViewController
    
    let previewView: PreviewUIView?
    private(set) var orientationPublisher : OrientationPublisher
    
    func makeUIViewController(context: Context) -> PreviewViewController {
        return PreviewViewController(previewView: self.previewView, orientationPublisher: orientationPublisher)
    }
    
    func updateUIViewController(_ uiViewController: PreviewViewController, context: Context) {}
}

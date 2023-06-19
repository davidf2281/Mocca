//
//  PreviewViewController.swift
//  Mocca
//
//  Created by David Fearon on 25/09/2020.
//

import UIKit
import SwiftUI

final class PreviewViewController: UIViewController {

    private let viewModel: PreviewViewControllerViewModelContract
    
    required init?(coder: NSCoder) {
        fatalError("Use initWithPreviewView: orientationPublisher:")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Use initWithPreviewView: orientationPublisher:")
    }
    
    required init(viewModel: PreviewViewControllerViewModelContract) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = viewModel.backgroundColor
        if let preview = self.viewModel.previewView {
            preview.frame = self.view.frame
            self.view.addSubview(preview)
        }
    }

    override func viewDidLayoutSubviews() {
        if let previewView = self.viewModel.previewView {
            let theFrame: CGRect = self.view.frame
            previewView.videoPreviewLayer?.frame = theFrame
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.viewModel.orientationPublisher.interfaceOrientation = Orientation.currentInterfaceOrientation()
            self.viewModel.previewView?.videoPreviewLayer?.captureConnection?.orientation =
            self.viewModel.orientationPublisher.interfaceOrientation
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
}

struct PreviewViewControllerRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PreviewViewController
    
    private let viewModel: PreviewViewControllerViewModel
    
    init(viewModel: PreviewViewControllerViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> PreviewViewController {
        return PreviewViewController(viewModel: self.viewModel)
    }
    
    func updateUIViewController(_ uiViewController: PreviewViewController, context: Context) {}
}

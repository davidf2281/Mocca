//
//  PreviewViewControllerViewModel.swift
//  Mocca
//
//  Created by David Fearon on 01/07/2023.
//

import UIKit

protocol PreviewViewControllerViewModelContract {
    var previewView: PreviewUIView? { get }
    var orientationPublisher: OrientationPublisher { get }
    var orientation: OrientationContract { get }
    var backgroundColor: UIColor { get }
}

struct PreviewViewControllerViewModel: PreviewViewControllerViewModelContract {
    
    private(set) var previewView: PreviewUIView?
    private(set) var orientationPublisher: OrientationPublisher
    private(set) var orientation: OrientationContract
    private(set) var backgroundColor = UIColor.black
    
    init(previewView: PreviewUIView?, orientationPublisher: OrientationPublisher, orientation: OrientationContract) {
        self.previewView = previewView
        self.orientationPublisher = orientationPublisher
        self.orientation = orientation
    }
}

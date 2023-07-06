//
//  PreviewViewControllerViewModel.swift
//  MoccaTests
//
//  Created by David Fearon on 01/07/2023.
//

import Foundation
import UIKit

class MockPreviewViewControllerViewModel: PreviewViewControllerViewModelContract {
    var previewView: PreviewUIView? = PreviewUIView(viewModel: PreviewUIViewModel())
    
    var orientationPublisher: OrientationPublisher = OrientationPublisher()
    
    var orientation: OrientationContract = Orientation()
    
    var backgroundColor: UIColor = UIColor.green
}

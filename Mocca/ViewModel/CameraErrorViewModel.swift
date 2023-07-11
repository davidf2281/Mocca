//
//  CameraErrorViewModel.swift
//  Mocca
//
//  Created by David Fearon on 26/06/2023.
//

import Foundation
import SwiftUI

struct CameraErrorViewModel {
    var displayText = "Oh, hey!\n\nLooks like something went wrong\nand your camera failed to start. Sorry.\n\nTry restarting the app."
    
    var textColor = Color(.sRGB, red: 0.3, green: 0.3, blue: 0.3, opacity: 1)
    
    var displayTextFont: Font {
        Font.system(size: 17, weight: .semibold)
    }
    
    var displayTextLineSpacing: CGFloat {
        7
    }
}

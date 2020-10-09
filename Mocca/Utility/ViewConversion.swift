//
//  ViewConversion.swift
//  Mocca
//
//  Created by David Fearon on 08/10/2020.
//

import Foundation
import CoreGraphics
import UIKit

class ViewConversion {
    
    /// Converts a logical position to a position to display, accounting for view orientstion
    /// - Parameters:
    ///   - position: The logical position in a given view
    ///   - orientation: Orientation of the view
    ///   - parentFrame: The frame of the view in which the position is located
    /// - Returns: A converted point for display
    class func displayPosition(position: CGPoint, orientation: UIInterfaceOrientation, parentFrame: CGSize) -> CGPoint {
        switch orientation {
        
        case .landscapeLeft:
            return CGPoint(x:parentFrame.width - position.y, y: position.x)
            
        case .landscapeRight:
            return CGPoint(x:position.y, y: parentFrame.height - position.x)
            
        case .portrait, .portraitUpsideDown:
            return CGPoint(x:position.x, y:position.y)
            
        default:
            assert(false, "Unhandled display position")
            return .zero
        }
    }
    
    /// Converts a tap position to a logical view position, accounting for view orientstion
    /// - Parameters:
    ///   - position: The position of the tap in a given view
    ///   - orientation: Orientation of the view
    ///   - parentFrame: The frame of the view in which the tap occurred
    /// - Returns: A converted logical tap point
    class func tapPosition(position: CGPoint, orientation: UIInterfaceOrientation, parentFrame: CGSize) -> CGPoint {
        switch orientation {
        
        case .landscapeLeft:
            return CGPoint(x:position.y, y: parentFrame.width - position.x)
            
        case .landscapeRight:
            return CGPoint(x:parentFrame.height - position.y, y: position.x)
            
        case .portrait, .portraitUpsideDown:
            return CGPoint(x:position.x, y:position.y)
            
        default:
            assert(false, "Unhandled display position")
            return .zero
        }
    }
    
    class func translationForDrag(translation: CGSize, orientation: UIInterfaceOrientation) -> CGSize {
        switch orientation {
        
        case .landscapeLeft:
            return CGSize(width:translation.height, height: -translation.width)
            
        case .landscapeRight:
            return CGSize(width:-translation.height, height: translation.width)
            
        case .portrait, .portraitUpsideDown:
            return CGSize(width:translation.width, height: translation.height)
            
        default:
            assert(false, "Unhandled drag translation")
            return .zero
        }
    }
    
    class func clamp(position:CGPoint, frame:CGSize, inset:CGFloat) -> CGPoint {
        return CGPoint(x: position.x < inset ? inset : position.x > (frame.width - inset) ? (frame.width - inset) : position.x,
                       y: position.y < inset ? inset : position.y > (frame.height - inset) ? (frame.height - inset) : position.y)
    }
}

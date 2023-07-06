//
//  MockUIViewControllerTransitionCoordinator.swift
//  MoccaTests
//
//  Created by David Fearon on 01/07/2023.
//

import Foundation
import UIKit

class MockUIViewControllerTransitionCoordinator: NSObject, UIViewControllerTransitionCoordinator {
    
    var animateAlongsideCallCount = 0
    func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        animateAlongsideCallCount += 1
        return false
    }
    
    func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
        
    }
    var isAnimated: Bool = false
    var presentationStyle: UIModalPresentationStyle = .automatic
    var initiallyInteractive: Bool = false
    var isInterruptible: Bool = false
    var isInteractive: Bool = false
    var isCancelled: Bool = false
    var transitionDuration: TimeInterval = 0
    var percentComplete: CGFloat = 0
    var completionVelocity: CGFloat = 0
    var completionCurve: UIView.AnimationCurve = .easeInOut
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        nil
    }
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        nil
    }
    var containerView: UIView = UIView()
    var targetTransform: CGAffineTransform = .identity

    func animateAlongsideTransition(in view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        return false
    }
    func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void) {
        
    }
    
}

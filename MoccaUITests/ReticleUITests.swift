//
//  ReticleUITests.swift
//  MoccaUITests
//
//  Created by David Fearon on 11/10/2020.
//

import XCTest

class ReticleUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    /// Reticle position after a tap can vary by a fraction of a point depending on device,
    /// so we allow a point's worth of tolerance.
    let tolerance = CGFloat(1)
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testReticleExists() {
        let reticle = app.otherElements["reticle"]
        XCTAssert(reticle.exists)
    }
    
    func testReticleMovesToCorrectPositionOnTap() {
        
        var tapPoint = CGPoint.zero
        var destinationPoint = CGPoint.zero
        
        tapPoint = CGPoint(x: 200,y: 50)
        destinationPoint = tapPreviewView(at: tapPoint)
        XCTAssert(point(destinationPoint, equalTo: tapPoint, tolerance: self.tolerance))

        tapPoint = CGPoint(x: 200,y: 120)
        destinationPoint = tapPreviewView(at: tapPoint)
        XCTAssert(point(destinationPoint, equalTo: tapPoint, tolerance: self.tolerance))

        tapPoint = CGPoint(x: 50,y: 50)
        destinationPoint = tapPreviewView(at: tapPoint)
        XCTAssert(point(destinationPoint, equalTo: tapPoint, tolerance: self.tolerance))
    }
    
    /*
     This test fails on physical devices due to what looks like an internal bug in XCUITest's query matching
     */
    #if targetEnvironment(simulator)
    func testReticleKeepsToCameraPreviewBounds() {
        
        var tapPoint = CGPoint.zero
        var destinationPoint = CGPoint.zero
        
        // Put the reticle somewhere away from the edge
        tapPoint = CGPoint(x: 200,y: 200)
        destinationPoint = tapPreviewView(at: tapPoint)
        XCTAssert(point(destinationPoint, equalTo: tapPoint, tolerance: self.tolerance))

        // Tap near the edge of the camera preview
        tapPoint = CGPoint(x: 1,y: 1)
        
        // We expect reticle position to be clamped to within the camera preview
        let expectedReticlePosition = CGPoint(x: 25, y: 25)
        
        destinationPoint = tapPreviewView(at: tapPoint)
        XCTAssert(point(destinationPoint, equalTo: expectedReticlePosition, tolerance: self.tolerance))
    }
    
    #endif
    
    
    /// Taps the preview at the given point
    /// - Parameter tapPoint: The point to tap
    /// - Returns: The actual UI position of the reticle after the tap
    func tapPreviewView(at tapPoint: CGPoint) -> CGPoint {
        let previewView = appPreviewView()
        XCTAssert(previewView.exists)
        
        let reticle = app.otherElements["reticle"]
        XCTAssert(reticle.exists)
        
        let coordinate = normalizedCoordinate(previewView, tapPoint)
        coordinate.tap()
        usleep(500000) // UI tests run in their own process; blocking call to usleep() is not a problem
        let reticlePosition = centrePoint(reticle)
        let convertedPoint = convertPoint(reticlePosition, to: previewView)
        return convertedPoint
    }
    
    func centrePoint(_ element:XCUIElement) -> CGPoint {
        return CGPoint(x: element.frame.origin.x + element.frame.size.width / 2,
                       y: element.frame.origin.y + element.frame.size.height / 2)
    }
    
    func normalizedCoordinate(_ element:XCUIElement, _ point: CGPoint) -> XCUICoordinate {
        let normalized = element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        return normalized.withOffset(CGVector(dx: point.x, dy: point.y))
    }
    
    func convertPoint(_ point: CGPoint, to: XCUIElement) -> CGPoint {
        return CGPoint(x: point.x - to.frame.origin.x, y:point.y - to.frame.origin.y)
    }
    
    func point(_ pointA: CGPoint, equalTo point: CGPoint, tolerance: CGFloat) -> Bool {
        return abs(point.x - pointA.x) < tolerance && abs(point.y - pointA.y) < tolerance
    }
    
    /// - Returns: The camera preview if running on device, or the placeholder image view on the simulator.
    /// Both have the same position and bounds so are good for the purpose of relative tap placement.
    func appPreviewView() -> XCUIElement {
        
        #if targetEnvironment(simulator)
        return XCUIApplication().images["simulator_preview"]
        #else
        
        /*
         We need to ferret about in the view hierarchy to find the camera preview because accessibility elements can't have sub-elements,
         thus we can't label both 'preview' and 'reticle' -- the first masks the second since one is the child of the other
         */
        return self.app.windows.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element(boundBy: 0).children(matching: .other).element
        #endif
    }
}

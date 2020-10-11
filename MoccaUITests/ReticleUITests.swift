//
//  ReticleUITests.swift
//  MoccaUITests
//
//  Created by David Fearon on 11/10/2020.
//

import XCTest

class ReticleUITests: XCTestCase {
    
    var app: XCUIApplication!
    
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
        
        let reticle = app.otherElements["reticle"]
        XCTAssert(reticle.exists)
        
        var tapPoint = CGPoint.zero
        var reticlePosition = CGPoint.zero
        
        tapPoint = CGPoint(x: 50,y: 50)
        tapCoordinate(app, tapPoint.x, tapPoint.y)
        sleep(1) // Wait for animation. Test process is in its own thread so blocking is not an issue
        reticlePosition = centrePoint(reticle)
        XCTAssertEqual(tapPoint, reticlePosition)
        
        tapPoint = CGPoint(x: 300,y: 300)
        tapCoordinate(app, tapPoint.x, tapPoint.y)
        sleep(1)
        reticlePosition = centrePoint(reticle)
        XCTAssertEqual(tapPoint, reticlePosition)
    }
    
    func testReticleKeepsToCameraPreviewBounds() {
        
        let reticle = app.otherElements["reticle"]
        XCTAssert(reticle.exists)
        
        var tapPoint = CGPoint.zero
        var reticlePosition = CGPoint.zero
        
        // Put the reticle somewhere in the middle
        tapPoint = CGPoint(x: 300,y: 300)
        tapCoordinate(app, tapPoint.x, tapPoint.y)
        sleep(1)
        reticlePosition = centrePoint(reticle)
        XCTAssertEqual(tapPoint, reticlePosition)
        
        // Tap near the edge of the camera preview
        tapPoint = CGPoint(x: 20,y: 20)
        tapCoordinate(app, tapPoint.x, tapPoint.y)
        sleep(1)
        reticlePosition = centrePoint(reticle)
        
        // We expect reticle position to be clamped to within the camera preview
        let expectedReticlePosition = CGPoint(x: 35, y: 45.5)
        XCTAssertEqual(expectedReticlePosition, reticlePosition)
    }
    
    func centrePoint(_ element:XCUIElement) -> CGPoint {
        return CGPoint(x: element.frame.origin.x + element.frame.size.width / 2,
                       y: element.frame.origin.y + element.frame.size.height / 2)
    }
    
    func tapCoordinate(_ element:XCUIElement, _ x: CGFloat,_ y: CGFloat) {
        let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
        coordinate.tap()
    }
}

//
//  ShutterButtonUITests.swift
//  MoccaUITests
//
//  Created by David Fearon on 11/10/2020.
//

import XCTest

class ShutterButtonUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    /*
     This test is considerably less than ideal since it's really only testing the state of the shutter button's viewmodel,
     not the visual state of the view itself. But it will at least catch unwanted states such as the shutter button
     disappearing or somehow being disabled before being tapped.
     */
    func testShutterButtonBecomesBusyOnTap() {
        let shutterButton = app.otherElements["shutterButton"]
        XCTAssert(shutterButton.exists)
        XCTAssertEqual(shutterButton.value as! String, "ready")
        shutterButton.tap()
        #if !targetEnvironment(simulator)
        XCTAssertEqual(shutterButton.value as! String, "busy")
        #else
        // On the simulator, the photo taker will error out because there's no valid capture manager
        XCTAssertEqual(shutterButton.value as! String, "error")
        #endif
    }
}

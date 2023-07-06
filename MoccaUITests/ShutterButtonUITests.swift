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

    func testShutterButtonExists() {
        let shutterButton = app.otherElements["shutterButton"]
        XCTAssert(shutterButton.exists)
    }
}

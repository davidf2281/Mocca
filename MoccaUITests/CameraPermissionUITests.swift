//
//  PhotoLibraryPermissionTests.swift
//  MoccaUITests
//
//  Created by David Fearon on 10/10/2020.
//

import XCTest

/*
 NOTE: Camera-permission tests must run on a physical device, not the simulator.
 */

class CameraPermissionUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    #if !targetEnvironment(simulator)
    
    func testCameraPermissionAlertAppearsOnLaunch() {
        
        app.resetAuthorizationStatus(for: .camera)
        
        app.launch() // Resetting authorization status kills the app
        
        let alertExpectation = expectation(description: "Alert expectation")
        
        addUIInterruptionMonitor(withDescription: "Permission alert") { (alert) -> Bool in
            let titleText = alert.staticTexts["“Mocca” Would Like to Access the Camera"]
            XCTAssert(titleText.exists)
            
            let bodyText = alert.staticTexts["Mocca needs access to your camera so you can take photos!"]
            XCTAssert(bodyText.exists)
            
            alert.buttons["OK"].tap()
            alertExpectation.fulfill()
            return true
        }
        
        app.tap() // We need to attempt a blocked interaction in order for UIInterruptionMonitor to fire
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    #endif
    
}

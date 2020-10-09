//
//  WidgetViewModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 08/10/2020.
//

import XCTest
@testable import Mocca

class WidgetViewModelTests: XCTestCase {

    private var manager: MockCaptureManager = MockCaptureManager()
    private var viewModel: WidgetViewModel!
    
    override func setUp() {
        manager = MockCaptureManager()
        viewModel = WidgetViewModel(captureManager:manager, dockedPosition:CGPoint(x: 110,y: 210), displayCharacter:"f")
    }

    func testInitialization() {
        XCTAssert(viewModel.dockedPosition == CGPoint(x: 110,y: 210))
        XCTAssertEqual(viewModel.displayCharacter, "f")
    }
    
    func testDragEndedSetsCaptureManagerExposurePointOfInterest() {
        XCTAssertFalse(manager.exposurePointOfInterestCalled)
        XCTAssertEqual(manager.exposureSetPoint, CGPoint.zero)
        let setPosition = CGPoint(x: 100,y: 100)
        
        viewModel.dragEnded(position: setPosition, frameSize: .zero)
        XCTAssertTrue(manager.exposurePointOfInterestCalled)
        XCTAssertEqual(manager.exposureSetPoint, setPosition)
    }
    
    func testDragEndedSetsCaptureManagerFocusPointOfInterest() {
        XCTAssertFalse(manager.focusPointOfInterestCalled)
        XCTAssertEqual(manager.focusSetPoint, CGPoint.zero)
        let setPosition = CGPoint(x: 100,y: 100)
        
        viewModel.dragEnded(position: setPosition, frameSize: .zero)
        XCTAssertTrue(manager.focusPointOfInterestCalled)
        XCTAssertEqual(manager.focusSetPoint, setPosition)
    }
}

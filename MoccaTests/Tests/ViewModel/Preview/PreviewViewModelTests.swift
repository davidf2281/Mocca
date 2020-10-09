//
//  PreviewViewModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 08/10/2020.
//

import XCTest
@testable import Mocca
class PreviewViewModelTests: XCTestCase {

    private var viewModel: PreviewViewModel!
    private var manager: MockCaptureManager = MockCaptureManager()
    
    override func setUp() {
        manager = MockCaptureManager()
        viewModel = PreviewViewModel(captureManager: manager)
    }

    func testCorrectAspectRatioReturned()  {
        XCTAssertEqual(viewModel.aspectRatio, 3/4)
    }
    
    func testTapSetsCaptureManagerExposurePointOfInterest() {
        XCTAssertFalse(manager.exposurePointOfInterestCalled)
        XCTAssertEqual(manager.exposureSetPoint, CGPoint.zero)
        let tapPosition = CGPoint(x: 100,y: 100)
        
        viewModel.tapped(position: tapPosition, frameSize: .zero)
        XCTAssertTrue(manager.exposurePointOfInterestCalled)
        XCTAssertEqual(manager.exposureSetPoint, tapPosition)
    }
    
    func testTapSetsCaptureManagerFocusPointOfInterest() {
        XCTAssertFalse(manager.focusPointOfInterestCalled)
        XCTAssertEqual(manager.focusSetPoint, CGPoint.zero)
        let tapPosition = CGPoint(x: 100,y: 100)
        
        viewModel.tapped(position: tapPosition, frameSize: .zero)
        XCTAssertTrue(manager.focusPointOfInterestCalled)
        XCTAssertEqual(manager.focusSetPoint, tapPosition)
    }
}

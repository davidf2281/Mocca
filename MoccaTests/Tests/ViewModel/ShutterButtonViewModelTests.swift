//
//  PhotoTakerTests.swift
//  MoccaTests
//
//  Created by David Fearon on 04/10/2020.
//

import XCTest
@testable import Mocca

class ShutterButtonViewModelTests: XCTestCase {

    func testModelStateBinding() {
        
        let photoTaker = MockCaptureManager()
        let shutterButtonViewModel = ShutterButtonViewModel(captureManager: photoTaker)
        
        XCTAssert(photoTaker.state == .ready)
        XCTAssert(shutterButtonViewModel.state == .ready)
        
        shutterButtonViewModel.tapped()
        
        XCTAssertEqual(photoTaker.takePhotoCalledCount, 1)
        print("\(shutterButtonViewModel.state)")
        let expectation = XCTestExpectation()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(0.1))) { // Wait for binding to propagate
            XCTAssert(shutterButtonViewModel.state == .capturePending)
            expectation.fulfill()
        }
        
        wait(for:[expectation], timeout:0.2)
    }
    
    func testTakePhotoCalledOnTap() {
        
        let photoTaker = MockCaptureManager()
        let shutterButtonViewModel = ShutterButtonViewModel(captureManager: photoTaker)
        XCTAssertEqual(photoTaker.takePhotoCalledCount, 0)
        
        shutterButtonViewModel.tapped()
        
        XCTAssertEqual(photoTaker.takePhotoCalledCount, 1)
    }
}

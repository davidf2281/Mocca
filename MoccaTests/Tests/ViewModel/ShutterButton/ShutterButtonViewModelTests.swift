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
        
        let photoTaker = MockPhotoTaker()
        let shutterButtonViewModel = ShutterButtonViewModel(photoTaker: photoTaker)
        
        XCTAssert(photoTaker.state == .ready)
        XCTAssert(shutterButtonViewModel.state == .ready)
        
        shutterButtonViewModel.tapped()
        
        XCTAssert(photoTaker.state == .capturePending)
        print("\(shutterButtonViewModel.state)")
        let expectation = XCTestExpectation()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(0.1))) { // Wait for binding to propagate
            XCTAssert(shutterButtonViewModel.state == .capturePending)
            expectation.fulfill()
        }
        
        wait(for:[expectation], timeout:0.2)
    }
    
    func testTakePhotoCalledOnTap() {
        
        let photoTaker = MockPhotoTaker()
        let shutterButtonViewModel = ShutterButtonViewModel(photoTaker: photoTaker)
        
        XCTAssert(photoTaker.takePhotoCalled == false)
        
        shutterButtonViewModel.tapped()
        
        XCTAssert(photoTaker.takePhotoCalled == true)
    }
}

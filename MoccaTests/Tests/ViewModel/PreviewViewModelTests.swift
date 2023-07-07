//
//  PreviewViewModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 08/10/2020.
//

import XCTest
@testable import Mocca
class PreviewViewModelTests: XCTestCase {

    private var sut: PreviewViewModel!
    private var manager: MockCaptureManager!
    private var device: MockCaptureDevice!
    private var layer: MockCaptureVideoPreviewLayer!
    override func setUp() {
        device = MockCaptureDevice()
        layer = MockCaptureVideoPreviewLayer()
        manager = MockCaptureManager(captureDevice: device, layer: layer)
        sut = PreviewViewModel(captureManager: manager)
    }

    func testCorrectAspectRatioReturned()  {
        XCTAssertEqual(sut.aspectRatio, 3/4)
    }
    
    func testTapSetsDeviceFocusPointOfInterest() {
        XCTAssertFalse(device.focusPointOfInterestSet)
        XCTAssertEqual(device.focusPointOfInterest, CGPoint.zero)
        let tapPosition = CGPoint(x: 100,y: 100)
        
        sut.tapped(position: tapPosition, frameSize: .zero)
        XCTAssertTrue(device.focusPointOfInterestSet)
        XCTAssertEqual(device.focusPointOfInterest, tapPosition)
    }
    
    func testTapSetsDeviceExposurePointOfInterest() {
        XCTAssertFalse(device.exposurePointOfInterestSet)
        XCTAssertEqual(device.exposurePointOfInterest, CGPoint.zero)
        let tapPosition = CGPoint(x: 100,y: 100)
        
        sut.tapped(position: tapPosition, frameSize: .zero)
        XCTAssertTrue(device.exposurePointOfInterestSet)
        XCTAssertEqual(device.exposurePointOfInterest, tapPosition)
    }
}

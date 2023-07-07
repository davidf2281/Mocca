//
//  WidgetViewModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 08/10/2020.
//

import XCTest
@testable import Mocca

class WidgetViewModelTests: XCTestCase {

    private var sut: WidgetViewModel!

    private var manager: MockCaptureManager = MockCaptureManager()
    private var device: MockCaptureDevice!
    private var layer: MockCaptureVideoPreviewLayer!
    
    override func setUp() {
        device = MockCaptureDevice()
        layer = MockCaptureVideoPreviewLayer()
        manager = MockCaptureManager(captureDevice: device, layer: layer)
        sut = WidgetViewModel(captureManager:manager, dockedPosition:CGPoint(x: 110,y: 210), displayCharacter:"f")
    }

    func testInitialization() {
        XCTAssert(sut.dockedPosition == CGPoint(x: 110,y: 210))
        XCTAssertEqual(sut.displayCharacter, "f")
    }

    func testDragEndedSetsDeviceFocusPointOfInterest() {
        XCTAssertFalse(device.focusPointOfInterestSet)
        XCTAssertEqual(device.focusPointOfInterest, CGPoint.zero)
        let setPosition = CGPoint(x: 100,y: 100)
        
        sut.dragEnded(position: setPosition, frameSize: .zero)
        XCTAssertTrue(device.focusPointOfInterestSet)
        XCTAssertEqual(device.focusPointOfInterest, setPosition)
    }

    func testDragEndedSetsDeviceExposurePointOfInterest() {
        XCTAssertFalse(device.exposurePointOfInterestSet)
        XCTAssertEqual(device.exposurePointOfInterest, CGPoint.zero)
        let setPosition = CGPoint(x: 100,y: 100)
        
        sut.dragEnded(position: setPosition, frameSize: .zero)
        
        XCTAssertTrue(device.exposurePointOfInterestSet)
        XCTAssertEqual(device.exposurePointOfInterest, setPosition)
    }
}

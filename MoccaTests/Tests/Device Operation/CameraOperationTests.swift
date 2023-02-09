//
//  CameraOperationTests.swift
//  MoccaTests
//
//  Created by David Fearon on 20/10/2020.
//

import XCTest
import AVFoundation
@testable import Mocca

class CameraOperationTests: XCTestCase {

    private var manager: MockCaptureManager = MockCaptureManager()
    private var device: MockAVCaptureDevice!
    private var layer: MockAVCaptureVideoPreviewLayer!
    private var utils: MockCaptureUtils!
    private var sut: CameraOperation!
    override func setUp() {
        utils = MockCaptureUtils()
        device = MockAVCaptureDevice()
        layer = MockAVCaptureVideoPreviewLayer()
        manager = MockCaptureManager(captureDevice: device, layer: layer)
        
        sut = CameraOperation()
    }
    
    func testSetIso() throws {
        XCTAssertEqual(device.iso, 0)
        try sut.setIso(200.0, for: device, utils: utils) { (CMTime) in }
        XCTAssert(device.iso == 200.0)
    }

    func testSetExposureDuration() throws {
        let currentTimescale = device.exposureDuration.timescale

        XCTAssertEqual(device.exposureDuration, .zero)
        try sut.setExposure(seconds: 0.1, for: device, utils: utils, completion: { (CMTime) in })
        
        XCTAssertEqual(device.exposureDuration, CMTimeMakeWithSeconds(0.1, preferredTimescale: currentTimescale))
    }

}

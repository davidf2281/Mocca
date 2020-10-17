//
//  DeviceCaptureManagerTests.swift
//  MoccaTests
//
//  Created by David Fearon on 17/10/2020.
//

import XCTest
@testable import Mocca

class DeviceCaptureManagerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testInitialization() {
        let session = MockAVCaptureSession()
        let output = AVCapturePhotoOutput()
        let device = MockAVCaptureDevice()
        let input = MockAVCaptureDeviceInput()
        
        // Initial conditions
        XCTAssert(session.canAddInput(input as! AVCaptureInput))
        
    }
}

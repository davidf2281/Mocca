//
//  DeviceCaptureManagerTests.swift
//  MoccaTests
//
//  Created by David Fearon on 17/10/2020.
//

import XCTest
import AVFoundation

@testable import Mocca

class DeviceCaptureManagerTests: XCTestCase {

    var session: MockAVCaptureSession!
    var output:  AVCapturePhotoOutput!
    var device:  MockAVCaptureDevice!
//    var input:   AVCaptureDeviceInput!
    
    override func setUp() {
         session = MockAVCaptureSession()
         output =  AVCapturePhotoOutput()
         device =  MockAVCaptureDevice()
//         input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()
    }

    func testInitialTestConditions() {
        // Initial conditions
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        XCTAssertTrue(session.canAddInput(input))
        XCTAssertTrue(session.canAddOutputResponse)
        
        XCTAssertNil(session.lastAddedInput)
        XCTAssertNil(session.lastAddedOutout)
        
        XCTAssertFalse(session.beginConfigirationCalled)
        XCTAssertFalse(session.addInputCalled)
        XCTAssertFalse(session.addOuputCalled)
        XCTAssertFalse(session.commitConfigurationCalled)
        XCTAssertFalse(session.startRunningCalled)
        XCTAssertFalse(session.stopRunningCalled)
        XCTAssertFalse(session.beginConfigurationNotCalledWhenRequired)
        XCTAssertFalse(session.commitConfigurationCalledPrematurely)
    }
    
    func testManagerInitializesCaptureSession() throws {
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        _ = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)
        
        XCTAssertTrue(session.beginConfigirationCalled)
        
        XCTAssertTrue(session.addInputCalled)
        XCTAssertTrue(session.lastAddedInput === input)

        XCTAssertTrue(session.addOuputCalled)
        XCTAssertTrue(session.lastAddedOutout === output)

        XCTAssertTrue(session.commitConfigurationCalled)
        
        XCTAssertFalse(session.beginConfigurationNotCalledWhenRequired)
        XCTAssertFalse(session.commitConfigurationCalledPrematurely)
    }
    
    func testStartSession() throws {
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        let sut = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)
        
        sut.startCaptureSession()
        XCTAssertTrue(session.startRunningCalled)
    }
    
    func testStopSession() throws {
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        let sut = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)
        
        sut.stopCaptureSession()
        XCTAssertTrue(session.stopRunningCalled)
    }
}

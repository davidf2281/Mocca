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
    
    var sut: CameraOperation!
    var mockDevice: MockAVCaptureDevice!
    var mockFormat: MockAVCaptureDeviceFormat!
    var mockUtils: MockCaptureUtils!
    
    override func setUpWithError() throws {
        sut = CameraOperation()
        mockDevice = MockAVCaptureDevice()
        mockFormat = MockAVCaptureDeviceFormat()
        mockUtils = MockCaptureUtils()
    }
    
    func testSetIsoSuccess() throws {
        
        // Initial conditions
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.iso, 0)
        mockUtils.minIsoToReturn = 50
        mockUtils.maxIsoToReturn = 2000
        
        let targetIso: Float = 100
        try sut.setIso(targetIso, for: mockDevice, utils: mockUtils, completion: {_ in})
        
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertTrue(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.iso, targetIso)
    }
    
    func testSetIsoFailure() throws {
        
        // Initial conditions
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.iso, 0)
        mockUtils.minIsoToReturn = 50
        mockUtils.maxIsoToReturn = 2000
        
        let targetIso: Float = 10000
        XCTAssertThrowsError(try sut.setIso(targetIso, for: mockDevice, utils: mockUtils, completion: {_ in}))
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.iso, 0)
    }
    
    func testSetExposureSuccess() throws {
        
        // Initial conditions
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.exposureDuration, .zero)
        
        let currentTimescale = mockDevice.exposureDuration.timescale
        
        try sut.setExposure(seconds: 0.1, for: mockDevice, utils: mockUtils, completion: { _ in })
        
        XCTAssertEqual(mockDevice.exposureDuration, CMTimeMakeWithSeconds(0.1, preferredTimescale: currentTimescale))
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertTrue(mockDevice.configurationWasLocked)
    }
    
    func testSetExposureFailure() throws {
        
        // Initial conditions
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.exposureDuration, .zero)
        
        mockFormat.maxExposureDurationToReturn = CMTimeMake(value: 1, timescale: 1)
        
       XCTAssertThrowsError(try sut.setExposure(seconds: 2, for: mockDevice, utils: mockUtils, completion: { _ in }))

        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.exposureDuration, .zero)
    }
    
    func testCanSetExposureTargetBiasSuccess() throws {
        
        mockDevice.minExposureTargetBias = 3
        mockDevice.maxExposureTargetBias = 8
        
        XCTAssertTrue(sut.canSetExposureTargetBias(ev: 4, for: mockDevice))
    }
    
    func testCanSetExposureTargetBiasFailure() throws {
        
        mockDevice.minExposureTargetBias = 3
        mockDevice.maxExposureTargetBias = 8
        
        XCTAssertFalse(sut.canSetExposureTargetBias(ev: 9, for: mockDevice))
    }
    
    func testwillTargetBiasHaveEffectSuccess() throws {
        mockFormat.maxISOToReturn = 1000
        mockFormat.minISOToReturn = 50
        mockDevice.iso = 200
        mockDevice.activeFormat = mockFormat
        mockDevice.minExposureTargetBias = -3
        mockDevice.maxExposureTargetBias = 3
        
        XCTAssertTrue(sut.willTargetBiasHaveEffect(ev: 5, for: mockDevice))
    }
    
    func testwillTargetBiasHaveEffectFailureTooHigh() throws {
        mockFormat.maxISOToReturn = 1000
        mockFormat.minISOToReturn = 50
        mockDevice.iso = 1000
        mockDevice.activeFormat = mockFormat
        mockDevice.minExposureTargetBias = -3
        mockDevice.maxExposureTargetBias = 3
        
        XCTAssertFalse(sut.willTargetBiasHaveEffect(ev: 4, for: mockDevice))
    }

    func testwillTargetBiasHaveEffectFailureTooLow() throws {
        mockFormat.maxISOToReturn = 1000
        mockFormat.minISOToReturn = 200
        mockDevice.iso = 200
        mockDevice.activeFormat = mockFormat
        mockDevice.minExposureTargetBias = -3
        mockDevice.maxExposureTargetBias = 3
        
        XCTAssertFalse(sut.willTargetBiasHaveEffect(ev: -3, for: mockDevice))
    }
    
    func testSetExposureTargetBiasSuccess() throws {
        
        // Initial conditions
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.exposureTargetBias, 0)
        
        mockDevice.minExposureTargetBias = -3
        mockDevice.maxExposureTargetBias = 3

        let targetBias: EV = 2
        
        try sut.setExposureTargetBias(ev: targetBias, for: mockDevice, completion: nil)
        
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertTrue(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.exposureTargetBias, targetBias)
    }
    
    func testSetExposureTargetBiasFailure() throws {
        
        // Initial conditions
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.exposureTargetBias, 0)
        
        mockDevice.minExposureTargetBias = -3
        mockDevice.maxExposureTargetBias = 3

        let targetBias: EV = 4
        
        XCTAssertThrowsError(try sut.setExposureTargetBias(ev: targetBias, for: mockDevice, completion: nil))
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.exposureTargetBias, 0)
    }
    
    
}

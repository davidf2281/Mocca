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
    var mockDevice: MockCaptureDevice!
    var mockFormat: MockAVCaptureDeviceFormat!
    var mockUtils: MockCaptureUtils!
    var mockVideoPreviewLayer: MockCaptureVideoPreviewLayer!
    
    override func setUpWithError() throws {
        sut = CameraOperation()
        mockDevice = MockCaptureDevice()
        mockFormat = MockAVCaptureDeviceFormat()
        mockUtils = MockCaptureUtils()
        mockVideoPreviewLayer = MockCaptureVideoPreviewLayer()
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
    
    func testSetExposurePointOfInterestSuccess() throws {
        
        // Initial conditions
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.exposurePointOfInterest, .zero)
        XCTAssertNil(mockVideoPreviewLayer.lastPointInLayer)
        XCTAssertEqual(mockDevice.exposureMode, .locked)
        
        let point = CGPoint(x: 100, y: 50)
        let result = sut.setExposurePointOfInterest(point, on: mockVideoPreviewLayer, for: mockDevice)
        
        guard case .success = result else { XCTFail(); return }
        XCTAssertEqual(mockVideoPreviewLayer.lastPointInLayer, point)
        XCTAssertEqual(mockDevice.exposurePointOfInterest, point)
        XCTAssertEqual(mockDevice.exposureMode, .autoExpose)
    }
    
    func testSetExposurePointOfInterestFailure() throws {
        
        // Initial conditions
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.exposurePointOfInterest, .zero)
        XCTAssertNil(mockVideoPreviewLayer.lastPointInLayer)
        XCTAssertEqual(mockDevice.exposureMode, .locked)
        
        mockDevice.lockForConfigurationShouldFail = true
        
        let point = CGPoint(x: 100, y: 50)
        let result = sut.setExposurePointOfInterest(point, on: mockVideoPreviewLayer, for: mockDevice)
        
        guard case .failure(let error) = result, error == .lockForConfigurationFailed else { XCTFail(); return }
        XCTAssertNil(mockVideoPreviewLayer.lastPointInLayer)
        XCTAssertEqual(mockDevice.exposurePointOfInterest, .zero)
        XCTAssertEqual(mockDevice.exposureMode, .locked)
    }
        
    func testSetFocusPointOfInterestSuccess() throws {
        
        // Initial conditions
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.focusPointOfInterest, .zero)
        XCTAssertNil(mockVideoPreviewLayer.lastPointInLayer)
        XCTAssertEqual(mockDevice.focusMode, .locked)
        
        let point = CGPoint(x: 100, y: 50)
        let result = sut.setFocusPointOfInterest(point, on: mockVideoPreviewLayer, for: mockDevice)
        
        guard case .success = result else { XCTFail(); return }
        XCTAssertEqual(mockVideoPreviewLayer.lastPointInLayer, point)
        XCTAssertEqual(mockDevice.focusPointOfInterest, point)
        XCTAssertEqual(mockDevice.focusMode, .autoFocus)
        XCTAssertTrue(mockDevice.focusPointOfInterestSet)
    }
    
    func testSetFocusPointOfInterestFailure() throws {
        
        // Initial conditions
        XCTAssertFalse(mockDevice.configurationLocked)
        XCTAssertFalse(mockDevice.configurationWasLocked)
        XCTAssertEqual(mockDevice.focusPointOfInterest, .zero)
        XCTAssertNil(mockVideoPreviewLayer.lastPointInLayer)
        XCTAssertEqual(mockDevice.focusMode, .locked)
        
        mockDevice.lockForConfigurationShouldFail = true
        
        let point = CGPoint(x: 100, y: 50)
        let result = sut.setFocusPointOfInterest(point, on: mockVideoPreviewLayer, for: mockDevice)
        
        guard case .failure(let error) = result, error == .lockForConfigurationFailed else { XCTFail(); return }
        XCTAssertNil(mockVideoPreviewLayer.lastPointInLayer)
        XCTAssertEqual(mockDevice.focusPointOfInterest, .zero)
        XCTAssertEqual(mockDevice.focusMode, .locked)
    }
    
    func testSetFocusPointOfInterestWhenUnsupported() throws {
        
        mockDevice.focusPointOfInterestSupportedToReturn = false
        
        let point = CGPoint(x: 100, y: 50)
        let result = sut.setFocusPointOfInterest(point, on: mockVideoPreviewLayer, for: mockDevice)
        
        guard case .failure(let error) = result, error == .focusPointOfInterestUnsupported else { XCTFail(); return }
        XCTAssertFalse(mockDevice.focusPointOfInterestSet)
    }
    
    func testSetExposurePointOfInterestWhenUnsupported() throws {
    
        mockDevice.exposurePointOfInterestSupportedToReturn = false
        
        let point = CGPoint(x: 100, y: 50)
        let result = sut.setExposurePointOfInterest(point, on: mockVideoPreviewLayer, for: mockDevice)
        
        guard case .failure(let error) = result, error == .exposurePointOfInterestUnsupported else { XCTFail(); return }
        XCTAssertFalse(mockDevice.exposurePointOfInterestSet)
    }
}

//
//  CaptureUtilsTests.swift
//  MoccaTests
//
//  Created by David Fearon on 10/02/2023.
//

import XCTest
@testable import Mocca

final class CaptureUtilsTests: XCTestCase {

    var sut: CaptureUtils!
    var mockDevice: MockAVCaptureDevice!
    var mockFormat: MockAVCaptureDeviceFormat!
    override func setUpWithError() throws {
        sut = CaptureUtils()
        mockDevice = MockAVCaptureDevice()
        mockFormat = MockAVCaptureDeviceFormat()
    }

    func testMinISO() throws {
        mockFormat.minISOToReturn = 75
        mockDevice.activeFormat = mockFormat
        XCTAssertEqual(sut.minIso(for: mockDevice), 75)
    }
    
    func testMaxISO() throws {
        mockFormat.maxISOToReturn = 2000
        mockDevice.activeFormat = mockFormat
        XCTAssertEqual(sut.maxIso(for: mockDevice), 2000)
    }
    
    func testMinExposureSeconds() throws {
        mockFormat.minExposureDurationToReturn = CMTimeMake(value: 5, timescale: 100)
        mockDevice.activeFormat = mockFormat
        XCTAssertEqual(sut.minExposureSeconds(for: mockDevice), 0.05)
    }
    
    func testMaxExposureSeconds() throws {
        mockFormat.maxExposureDurationToReturn = CMTimeMake(value: 12, timescale: 1)
        mockDevice.activeFormat = mockFormat
        XCTAssertEqual(sut.maxExposureSeconds(for: mockDevice), 12)
    }
    
    func testHighestResolutionFullRangeVideoFormat() throws {
        
        let mockFormatDescription1 = MockCFFormatDescription()
        mockFormatDescription1.dimensionsToReturn = CMVideoDimensions(width: 100, height: 100)
        let mockFormat1 = MockAVCaptureDeviceFormat()
        mockFormat1.formatDescriptionToReturn = mockFormatDescription1
        
        let mockFormatDescription2 = MockCFFormatDescription()
        mockFormatDescription2.dimensionsToReturn = CMVideoDimensions(width: 400, height: 300)
        let mockFormat2 = MockAVCaptureDeviceFormat()
        mockFormat2.formatDescriptionToReturn = mockFormatDescription2
        
        let mockFormatDescription3 = MockCFFormatDescription()
        mockFormatDescription3.dimensionsToReturn = CMVideoDimensions(width: 200, height: 200)
        let mockFormat3 = MockAVCaptureDeviceFormat()
        mockFormat3.formatDescriptionToReturn = mockFormatDescription3
        
        let mockDevice = MockAVCaptureDevice()
        mockDevice.formatsToReturn = [mockFormat1, mockFormat2, mockFormat3]
        let sut = CaptureUtils()
        let result = sut.highestResolutionFullRangeVideoFormat(mockDevice)
        
        XCTAssert(result === mockFormat2)
    }
    
    func testHighestResolutionFullRangeVideoFormatWithNonFullRangeFormat() throws {
        
        let mockFormatDescription1 = MockCFFormatDescription()
        mockFormatDescription1.dimensionsToReturn = CMVideoDimensions(width: 100, height: 100)
        let mockFormat1 = MockAVCaptureDeviceFormat()
        mockFormat1.formatDescriptionToReturn = mockFormatDescription1
        
        let mockFormatDescription2 = MockCFFormatDescription()
        mockFormatDescription2.dimensionsToReturn = CMVideoDimensions(width: 400, height: 300)
        mockFormatDescription2.mediaSubTypeToReturn = CMFormatDescription.MediaSubType.pixelFormat_32BGRA
        let mockFormat2 = MockAVCaptureDeviceFormat()
        mockFormat2.formatDescriptionToReturn = mockFormatDescription2
        
        let mockFormatDescription3 = MockCFFormatDescription()
        mockFormatDescription3.dimensionsToReturn = CMVideoDimensions(width: 200, height: 200)
        let mockFormat3 = MockAVCaptureDeviceFormat()
        mockFormat3.formatDescriptionToReturn = mockFormatDescription3
        
        let mockDevice = MockAVCaptureDevice()
        mockDevice.formatsToReturn = [mockFormat1, mockFormat2, mockFormat3]
        let sut = CaptureUtils()
        let result = sut.highestResolutionFullRangeVideoFormat(mockDevice)
        
        XCTAssert(result === mockFormat3)
    }

}

private class EmptyAVCaptureDeviceFormat: AVCaptureDeviceFormatContract {}

class MockAVCaptureDeviceFormat: AVCaptureDeviceFormatContract {
    
    var minISOToReturn: Float = 0
    var minISO: Float {
        minISOToReturn
    }
    
    var maxISOToReturn: Float = 0
    var maxISO: Float {
        maxISOToReturn
    }
    
    var minExposureDurationToReturn: CMTime = .zero
    var minExposureDuration: CMTime {
        minExposureDurationToReturn
    }
    
    var maxExposureDurationToReturn: CMTime = .zero
    var maxExposureDuration: CMTime {
        maxExposureDurationToReturn
    }
    
    var formatDescriptionToReturn: CMFormatDescriptionContract = MockCFFormatDescription()
    var formatDescription: CMFormatDescriptionContract {
        formatDescriptionToReturn
    }

}

class MockCFFormatDescription: CMFormatDescriptionContract {
    
    var dimensionsToReturn = CMVideoDimensions(width: 100, height: 50)
    var dimensions: CMVideoDimensions {
        dimensionsToReturn
    }
    
    var mediaSubTypeToReturn = CMFormatDescription.MediaSubType(rawValue: 875704422)
    var mediaSubType: CMFormatDescription.MediaSubType {
        return mediaSubTypeToReturn
    }
}

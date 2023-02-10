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
}

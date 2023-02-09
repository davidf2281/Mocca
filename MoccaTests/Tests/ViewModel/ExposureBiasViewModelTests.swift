//
//  ExposureBiasViewModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 09/02/2023.
//

import XCTest
@testable import Mocca

final class ExposureBiasViewModelTests: XCTestCase {

    func testDragged() {
        
        let mockCaptureManager = MockCaptureManager()
        let mockCameraOperation = MockCameraOperation()
        let sut = ExposureBiasViewModel(captureManager: mockCaptureManager, cameraOperation: mockCameraOperation)
        
        // Initial conditions
        XCTAssertEqual(sut.compensation, 0.0)
        
        sut.dragged(extent: 1.0)
        
        XCTAssertEqual(sut.compensation, 0.01)
    }
}

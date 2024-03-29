//
//  ExposureBiasViewModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 09/02/2023.
//

import XCTest
@testable import Mocca

final class ExposureBiasViewModelTests: XCTestCase {

    var mockCaptureManager: MockCaptureManager!
    var mockCameraOperation: MockCameraOperation!
    var sut: ExposureBiasViewModel!
    
    override func setUpWithError() throws {
        mockCaptureManager = MockCaptureManager()
        mockCameraOperation = MockCameraOperation()
        sut = ExposureBiasViewModel(captureManager: mockCaptureManager, cameraOperation: mockCameraOperation)
    }
    
    func testDragChangesExposureCompensaton() {
     
        // Initial conditions
        XCTAssertEqual(sut.compensation, 0.0)
        
        sut.dragged(extent: 1.0)
        
        XCTAssertEqual(sut.compensation, 0.01)
    }
    
    func testDragWhenSetExpsoureTargetBiasCannotBeSet() {

        mockCameraOperation.setExposureTargetBiasShouldThrow = true
        
        // Initial conditions
        XCTAssertEqual(sut.compensation, 0.0)
        
        sut.dragged(extent: 1.0)
        
        XCTAssertEqual(sut.compensation, 0.0)
    }
    
    func testDragMustEndBeforeNewDragPermitted() {
    
        // Initial conditions
        XCTAssertEqual(sut.compensation, 0.0)
        
        sut.dragged(extent: 1.0)
        
        XCTAssertEqual(sut.compensation, 0.01)
        
        sut.dragged(extent: 1.0)
        
        XCTAssertEqual(sut.compensation, 0.01)

        sut.dragEnded()
        
        sut.dragged(extent: 1.0)

        XCTAssertEqual(sut.compensation, 0.02)
    }
}

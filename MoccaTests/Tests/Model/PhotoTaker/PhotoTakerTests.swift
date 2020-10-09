//
//  PhotoTakerTests.swift
//  MoccaTests
//
//  Created by David Fearon on 05/10/2020.
//

import XCTest
@testable import Mocca

class DevicePhotoTakerTests: XCTestCase {

    private var manager: MockCaptureManager = MockCaptureManager()
    private var photoLibrary: MockPHPhotoLibrary = MockPHPhotoLibrary()
    private var taker: DevicePhotoTaker!
    
    override func setUp() {
        manager = MockCaptureManager()
        photoLibrary = MockPHPhotoLibrary()
        taker = DevicePhotoTaker(captureManager: manager, photoLibrary: photoLibrary)
    }
    
    func testSetUp() {
        XCTAssertNotNil(manager)
        XCTAssertNotNil(photoLibrary)
        XCTAssertNotNil(taker)
    }
    
    func testPhotoTakerAsksCaptureManagerToTakePhoto() throws {
        XCTAssertFalse(manager.capturePhotoCalled)
        taker.takePhoto()
        XCTAssertTrue(manager.capturePhotoCalled)
    }
    
    func testPhotoTakerSetsItselfAsCaptureDelegate() {
        XCTAssertNil(manager.captureDelegate)
        taker.takePhoto()
        XCTAssertNotNil(manager.captureDelegate)
        XCTAssert(taker === manager.captureDelegate)
    }
    
    func testPhotoTakerCallsPerformChangesOnPhotoLibrary() {
        XCTAssertFalse(photoLibrary.performChangesCalled)
        taker.takePhoto()
        taker.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: nil)
        XCTAssertTrue(photoLibrary.performChangesCalled)
    }
    
    func testPhotoTakerSetsStateCorrectly {
        // Initial conditions
        XCTAssert(taker.state == .ready)
        XCTAssertTrue(photoLibrary.shouldSucceedOnPerformChanges)
        
        taker.takePhoto()
        XCTAssert(taker.state == .busy)
        taker.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: nil)
        XCTAssert
    }
}

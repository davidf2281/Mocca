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
    
    func waitForSimulatedDiskWrite() {
        let expectation = XCTestExpectation()
        _ = XCTWaiter.wait(for: [expectation], timeout: 0.2)
    }
    
    func testPhotoTakerAsksCaptureManagerToTakePhoto() throws {
        XCTAssertFalse(manager.capturePhotoCalled)
        _ = taker.takePhoto()
        XCTAssertTrue(manager.capturePhotoCalled)
    }
    
    func testPhotoTakerSetsItselfAsCaptureDelegate() {
        XCTAssertNil(manager.captureDelegate)
        _ = taker.takePhoto()
        XCTAssertNotNil(manager.captureDelegate)
        XCTAssert(taker === manager.captureDelegate)
    }
    
    func testPhotoTakerCallsPerformChangesOnPhotoLibrary() {
        XCTAssertFalse(photoLibrary.performChangesCalled)
        _ = taker.takePhoto()
        taker.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: nil)
        XCTAssertTrue(photoLibrary.performChangesCalled)
    }
    
    func testPhotoTakerStateSequenceForSuccessfulCapture() {
        
        photoLibrary.shouldSucceedOnPerformChanges = true

        XCTAssert(taker.state == .ready)
        XCTAssertTrue(photoLibrary.shouldSucceedOnPerformChanges)
        
        _ = taker.takePhoto()
        XCTAssert(taker.state == .capturePending)
        
        taker.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: nil)
        XCTAssert(taker.state == .saving)

        waitForSimulatedDiskWrite()
        
        XCTAssert(taker.state == .ready)
    }
    
    func testPhotoTakerStateSequenceForErroredCaptureButSuccessfulSave() {
        
        photoLibrary.shouldSucceedOnPerformChanges = true

        XCTAssert(taker.state == .ready)
        XCTAssertTrue(photoLibrary.shouldSucceedOnPerformChanges)
        
        _ = taker.takePhoto()
        XCTAssert(taker.state == .capturePending)
        
        taker.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: NSError())
        
        XCTAssert(taker.state == .error(.captureError))
        waitForSimulatedDiskWrite()
        XCTAssert(taker.state == .ready)
    }
    
    func testPhotoTakerStateSequenceForFailedCaptureAndFailedSave() {
        
        photoLibrary.shouldSucceedOnPerformChanges = false
        
        XCTAssert(taker.state == .ready)
        XCTAssertFalse(photoLibrary.shouldSucceedOnPerformChanges)
        
        _ = taker.takePhoto()
        XCTAssert(taker.state == .capturePending)
        
        taker.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: NSError())
                
        XCTAssert(taker.state == .error(.captureError))
        waitForSimulatedDiskWrite()
        XCTAssert(taker.state == .error(.saveError))
    }
}

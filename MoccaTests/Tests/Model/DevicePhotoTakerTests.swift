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
    private var sut: DevicePhotoTaker!
    
    override func setUp() {
        manager = MockCaptureManager()
        photoLibrary = MockPHPhotoLibrary()
        sut = DevicePhotoTaker(captureManager: manager, photoLibrary: photoLibrary)
    }
    
    func waitForSimulatedDiskWrite() {
        let expectation = XCTestExpectation()
        _ = XCTWaiter.wait(for: [expectation], timeout: 0.2)
    }
    
    func testPhotoTakerAsksCaptureManagerToTakePhoto() throws {
        XCTAssertFalse(manager.capturePhotoCalled)
        _ = sut.takePhoto()
        XCTAssertTrue(manager.capturePhotoCalled)
    }
    
    func testPhotoTakerSetsItselfAsCaptureDelegate() {
        XCTAssertNil(manager.captureDelegate)
        _ = sut.takePhoto()
        XCTAssertNotNil(manager.captureDelegate)
        XCTAssert(sut === manager.captureDelegate)
    }
    
    func testPhotoTakerCallsPerformChangesOnPhotoLibrary() {
        XCTAssertFalse(photoLibrary.performChangesCalled)
        _ = sut.takePhoto()
        sut.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: nil)
        XCTAssertTrue(photoLibrary.performChangesCalled)
    }
    
    func testPhotoTakerStateSequenceForSuccessfulCapture() {
        
        photoLibrary.shouldSucceedOnPerformChanges = true

        XCTAssert(sut.state == .ready)
        XCTAssertTrue(photoLibrary.shouldSucceedOnPerformChanges)
        
        _ = sut.takePhoto()
        XCTAssert(sut.state == .capturePending)
        
        sut.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: nil)
        XCTAssert(sut.state == .saving)

        waitForSimulatedDiskWrite()
        
        XCTAssert(sut.state == .ready)
    }
    
    func testPhotoTakerStateSequenceForErroredCaptureButSuccessfulSave() {
        
        photoLibrary.shouldSucceedOnPerformChanges = true

        XCTAssert(sut.state == .ready)
        XCTAssertTrue(photoLibrary.shouldSucceedOnPerformChanges)
        
        _ = sut.takePhoto()
        XCTAssert(sut.state == .capturePending)
        
        sut.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: NSError())
        
        XCTAssert(sut.state == .error(.captureError))
        waitForSimulatedDiskWrite()
        XCTAssert(sut.state == .ready)
    }
    
    func testPhotoTakerStateSequenceForFailedCaptureAndFailedSave() {
        
        photoLibrary.shouldSucceedOnPerformChanges = false
        
        XCTAssert(sut.state == .ready)
        XCTAssertFalse(photoLibrary.shouldSucceedOnPerformChanges)
        
        _ = sut.takePhoto()
        XCTAssert(sut.state == .capturePending)
        
        sut.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: NSError())
                
        XCTAssert(sut.state == .error(.captureError))
        waitForSimulatedDiskWrite()
        XCTAssert(sut.state == .error(.saveError))
    }
    
    func testPhotoTakerResetState() {
        
        photoLibrary.shouldSucceedOnPerformChanges = false
        XCTAssert(sut.state == .ready)
        _ = sut.takePhoto()
        sut.photoOutput(AVCapturePhotoOutput(), didFinishProcessingPhoto: UnavailableInitFactory.instanceOfAVCapturePhoto(), error: NSError())
        waitForSimulatedDiskWrite()
        XCTAssert(sut.state == .error(.saveError))
        
        let result = sut.resetState()
        guard case .success(.ready) = result else {
            XCTFail()
            return
        }

        XCTAssertEqual(sut.state, .ready)
    }
}

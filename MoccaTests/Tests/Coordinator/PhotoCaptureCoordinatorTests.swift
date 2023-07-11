//
//  PhotoCaptureCoordinatorTests.swift
//  MoccaTests
//
//  Created by David Fearon on 11/07/2023.
//

import XCTest

final class PhotoCaptureCoordinatorTests: XCTestCase {

    var sut: PhotoCaptureCoordinator!
    var mockCaptureManager: MockCaptureManager!
    var mockPhotoLibrary: MockPhotoLibrary!
    
    override func setUpWithError() throws {
        mockCaptureManager = MockCaptureManager()
        mockPhotoLibrary = MockPhotoLibrary()
        sut = PhotoCaptureCoordinator(captureManager: mockCaptureManager, photoLibrary: mockPhotoLibrary)
    }

    func testCaptureManagerDelegateSet() throws {
        XCTAssertIdentical(mockCaptureManager.delegate, sut)
    }
    
    func testDidFinishProcessingPhotoAddsPhotoToLibraryOnSuccess() {
        let photo = MockPhoto()
        sut.didFinishProcessingPhoto(photo, error: nil)
        XCTAssertEqual(mockPhotoLibrary.addPhotoCallCount, 1)
        XCTAssertIdentical(mockPhotoLibrary.photoAdded, photo)
    }
}

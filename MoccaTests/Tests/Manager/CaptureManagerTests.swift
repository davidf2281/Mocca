//
//  CaptureManagerTests.swift
//  MoccaTests
//
//  Created by David Fearon on 09/07/2023.
//

import XCTest
import AVFoundation.AVError
@testable import Mocca

// TODO: These tests taken from old session(capture)manager tests

class CaptureManagerTests: XCTestCase {
    
    var sut: CaptureManager!
    var mockPhotoOutput: MockCapturePhotoOutput!
    var mockPhotoCaptureIntermediary: PhotoCaptureIntermediary!
    var mockPhotoSettingsProvider: MockPhotoSettingsProvider!
    var mockCaptureManagerDelegate: MockCaptureManagerDelegate!
    
    override func setUpWithError() throws {
        
        mockPhotoOutput = MockCapturePhotoOutput()
        mockPhotoCaptureIntermediary = PhotoCaptureIntermediary()
        mockPhotoSettingsProvider = MockPhotoSettingsProvider()
        mockCaptureManagerDelegate = MockCaptureManagerDelegate()
        sut = CaptureManager(photoOutput: mockPhotoOutput, photoCaptureIntermediary: mockPhotoCaptureIntermediary, settingsProvider: mockPhotoSettingsProvider)
        sut.delegate = mockCaptureManagerDelegate
    }
    
    func testPhotoCaptureIntermediaryDelegateSet() {
        XCTAssertIdentical(mockPhotoCaptureIntermediary.delegate, sut)
    }
    
    func testStateTransitionsToPendingOnTakePhoto() throws {
        
        XCTAssertEqual(sut.state, .ready)
        
        sut.capturePhoto()
        
        XCTAssertEqual(sut.state, .capturePending)
    }
    
    func testPhotoOutputCaptureCalledOnTakePhoto() throws {
        
        XCTAssertEqual(mockPhotoOutput.captureCallCount, 0)
        
        sut.capturePhoto()
        
        XCTAssertEqual(mockPhotoOutput.captureCallCount, 1)
    }
    
    func testResetState() throws {
        
        sut.capturePhoto()
        XCTAssertEqual(sut.state, .capturePending)
        
        let result = sut.resetState()
        XCTAssertEqual(sut.state, .ready)
        XCTAssertEqual(result, .success(.ready))
    }
    
    func testCallsDelegateDidFinishProcessingOnNoError() throws {
        
        let mockPhoto = MockPhoto()
        
        sut.capturePhoto()
        
        sut.didFinishProcessingPhoto(mockPhoto, error: nil)
        
        XCTAssertEqual(mockCaptureManagerDelegate.didFinishProcessingPhotoCallCount, 1)
        XCTAssertIdentical(mockPhoto, mockCaptureManagerDelegate.photoReceived as? AnyObject)
        XCTAssertEqual(sut.state, .ready)
    }
    
    
    func testAddsPhotoToLibraryOnProcessingError() throws {
        
        let mockPhoto = MockPhoto()
        let mockError: TestError = .fail
        sut.capturePhoto()
        
        sut.didFinishProcessingPhoto(mockPhoto, error: mockError)

        XCTAssertEqual(mockCaptureManagerDelegate.didFinishProcessingPhotoCallCount, 1)
        XCTAssertIdentical(mockPhoto, mockCaptureManagerDelegate.photoReceived as? AnyObject)
        XCTAssertEqual(mockError, mockCaptureManagerDelegate.errorReceived as! TestError)
        XCTAssertEqual(sut.state, .ready)
    }
}

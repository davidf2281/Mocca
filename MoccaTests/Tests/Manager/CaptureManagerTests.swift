//
//  CaptureManagerTests.swift
//  MoccaTests
//
//  Created by David Fearon on 09/07/2023.
//

import XCTest
@testable import Mocca

// TODO: These tests taken from old session(capture)manager tests

/*
class CaptureManagerTests: XCTestCase {
    
    func testStateTransitionsToPendingOnTakePhoto() throws {
        
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        XCTAssertEqual(sut.state, .ready)
        
        sut.takePhoto()
        
        XCTAssertEqual(sut.state, .capturePending)
    }
    
    func testPhotoOutputCaptureCalledOnTakePhoto() throws {
        
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        XCTAssertEqual(mockPhotoOutput.captureCallCount, 0)
        
        sut.takePhoto()
        
        XCTAssertEqual(mockPhotoOutput.captureCallCount, 1)
    }
    
    func testResetState() throws {
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        sut.takePhoto()
        XCTAssertEqual(sut.state, .capturePending)
        
        let result = sut.resetState()
        XCTAssertEqual(sut.state, .ready)
        XCTAssertEqual(result, .success(.ready))
    }
    
    func testAddsPhotoToLibraryOnNoError() throws {
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        let mockPhoto = MockPhoto()
        mockPhotoLibrary.successToReturn = true
        mockPhotoLibrary.errorToReturn = nil
        mockPhotoLibrary.addPhotoCallCount = 0
        sut.takePhoto()
        XCTAssertEqual(sut.state, .capturePending)
        
        sut.didFinishProcessingPhoto(mockPhoto, error: nil)
        
        XCTAssertEqual(mockPhotoLibrary.addPhotoCallCount, 1)
        XCTAssertIdentical(mockPhoto, mockPhotoLibrary.photoAdded as? AnyObject)
        XCTAssertEqual(sut.state, .ready)
    }
    
    func testAddsPhotoToLibraryOnProcessingError() throws {
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        let mockPhoto = MockPhoto()
        mockPhotoLibrary.successToReturn = true
        mockPhotoLibrary.errorToReturn = nil
        mockPhotoLibrary.addPhotoCallCount = 0
        sut.takePhoto()
        XCTAssertEqual(sut.state, .capturePending)
        
        sut.didFinishProcessingPhoto(mockPhoto, error: AVError(_nsError: NSError(domain: "", code: 0)))
        
        XCTAssertEqual(mockPhotoLibrary.addPhotoCallCount, 1)
        XCTAssertIdentical(mockPhoto, mockPhotoLibrary.photoAdded as? AnyObject)
        XCTAssertEqual(sut.state, .ready)
    }
    
    func testStateIsErrorOnPhotoLibraryError() throws {
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        let mockPhoto = MockPhoto()
        mockPhotoLibrary.successToReturn = false
        mockPhotoLibrary.errorToReturn = PhotoTakerError.saveError
        mockPhotoLibrary.addPhotoCallCount = 0
        sut.takePhoto()
        XCTAssertEqual(sut.state, .capturePending)
        
        sut.didFinishProcessingPhoto(mockPhoto, error: nil)
        
        XCTAssertEqual(mockPhotoLibrary.addPhotoCallCount, 1)
        XCTAssertIdentical(mockPhoto, mockPhotoLibrary.photoAdded as? AnyObject)
        XCTAssertEqual(sut.state, .error(mockPhotoLibrary.errorToReturn as! PhotoTakerError))
    }
}
*/

//
//  DeviceCaptureManagerTests.swift
//  MoccaTests
//
//  Created by David Fearon on 17/10/2020.
//

import XCTest
import AVFoundation

@testable import Mocca

class DeviceCaptureManagerTests: XCTestCase {
    
    var mockCaptureSession: MockCaptureSession!
    var mockPhotoOutput: MockCapturePhotoOutput!
    var mockVideoOutput: MockVideoOutput!
    var mockDevice:  MockCaptureDevice!
    var mockResources: MockResources!
    var mockPreviewLayer: MockCaptureVideoPreviewLayer!
    var mockPhotoLibrary: MockPhotoLibrary!
    var mockInput: MockCaptureDeviceInput!
    
    override func setUp() {
        mockCaptureSession = MockCaptureSession()
        mockPhotoOutput = MockCapturePhotoOutput()
        mockVideoOutput = MockVideoOutput()
        mockDevice =  MockCaptureDevice()
        mockResources = MockResources()
        mockPreviewLayer = MockCaptureVideoPreviewLayer()
        mockPhotoLibrary = MockPhotoLibrary()
        mockInput = MockCaptureDeviceInput()
    }
    
    func testInitialTestConditions() {
        // Initial conditions
        XCTAssertTrue(mockCaptureSession.canAddInput(mockInput))
        XCTAssertTrue(mockCaptureSession.canAddPhotoOutputResponse)
        XCTAssertTrue(mockCaptureSession.canAddVideoOutputResponse)

        XCTAssertNil(mockCaptureSession.lastAddedInput)
        XCTAssertNil(mockCaptureSession.lastAddedOutput)
        
        XCTAssertFalse(mockCaptureSession.beginConfigirationCalled)
        XCTAssertFalse(mockCaptureSession.addInputCalled)
        XCTAssertFalse(mockCaptureSession.addOuputCalled)
        XCTAssertFalse(mockCaptureSession.commitConfigurationCalled)
        XCTAssertFalse(mockCaptureSession.startRunningCalled)
        XCTAssertFalse(mockCaptureSession.stopRunningCalled)
        XCTAssertFalse(mockCaptureSession.beginConfigurationNotCalledWhenRequired)
        XCTAssertFalse(mockCaptureSession.commitConfigurationCalledPrematurely)
    }
    
    func testManagerInitializesCaptureSession() throws {
        
        _ = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
        XCTAssertTrue(mockCaptureSession.beginConfigirationCalled)
        
        XCTAssertTrue(mockCaptureSession.addInputCalled)
        XCTAssertTrue(mockCaptureSession.lastAddedInput as? AnyObject === mockInput)
        
        XCTAssertTrue(mockCaptureSession.addOuputCalled)
        XCTAssertTrue(mockCaptureSession.lastAddedOutput as? AnyObject === mockVideoOutput)
        
        XCTAssertTrue(mockCaptureSession.commitConfigurationCalled)
        
        XCTAssertFalse(mockCaptureSession.beginConfigurationNotCalledWhenRequired)
        XCTAssertFalse(mockCaptureSession.commitConfigurationCalledPrematurely)
    }
    
    func testManagerInitializesCaptureSessionWithAddInputFailure() {

        mockCaptureSession.canAddInputResponse = false
        
        do {
            _ = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        } catch CaptureManagerError.addVideoInputFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testManagerInitializesCaptureSessionWithAddVideoOutputFailure() {

        mockCaptureSession.canAddVideoOutputResponse = false
        
        do {
            _ = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        } catch CaptureManagerError.addVideoDataOutputFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testManagerConvenienceInitializesCaptureSession() {

#if targetEnvironment(simulator)
        do {
            _ = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        } catch CaptureManagerError.captureDeviceNotFound {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
#else
        do {
            _ = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: DeviceResources(captureDevice: AVCaptureDevice.default(for: .video))!, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        } catch {
            XCTFail("Convenience init should not fail on physical device")
        }
#endif
    }
    
    func testManagerInitializesCaptureSessionWithAddOutputFailure() {
        
        mockCaptureSession.canAddPhotoOutputResponse = false
        
        do {
            _ = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        } catch CaptureManagerError.addPhotoOutputFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testStartSession() throws {
        
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
        
        sut.startCaptureSession()
        XCTAssertTrue(mockCaptureSession.startRunningCalled)
    }
    
    func testStopSession() throws {
        
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
        
        sut.stopCaptureSession()
        XCTAssertTrue(mockCaptureSession.stopRunningCalled)
    }
    
    func testSuccessfulSelectionOfDeviceCamera() throws {
        
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
        let logicalDevice = LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back)
        let newMockDevice = MockCaptureDevice()
        
        mockResources.deviceToReturn = newMockDevice
        
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === mockDevice)
        
        let result = sut.selectCamera(type: logicalDevice)
        guard case .success = result else {
            XCTFail()
            return
        }
        
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === newMockDevice)
    }
    
    func testUnsuccessfulSelectionOfDeviceCamera() throws {
        
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
        let logicalDevice = LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back)
        let newMockDevice = MockCaptureDevice()
        
        mockResources.deviceToReturn = newMockDevice
        mockResources.physicalDeviceCallShouldSucceed = false
        
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === mockDevice)
        
        let result = sut.selectCamera(type: logicalDevice)
        guard case .failure(.captureDeviceNotFound) = result else {
            XCTFail()
            return
        }
        
        // Check originally selected camera is still selected
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === mockDevice)
    }
    
    func testStateTransitionsToPendingOnTakePhoto() throws {
        
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
        XCTAssertEqual(sut.state, .ready)
        
        sut.takePhoto()
        
        XCTAssertEqual(sut.state, .capturePending)
    }
    
    func testPhotoOutputCaptureCalledOnTakePhoto() throws {
        
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
        XCTAssertEqual(mockPhotoOutput.captureCallCount, 0)
        
        sut.takePhoto()
        
        XCTAssertEqual(mockPhotoOutput.captureCallCount, 1)
    }
    
    func testResetState() throws {
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
        sut.takePhoto()
        XCTAssertEqual(sut.state, .capturePending)
        
        let result = sut.resetState()
        XCTAssertEqual(sut.state, .ready)
        XCTAssertEqual(result, .success(.ready))
    }
    
    func testAddsPhotoToLibraryOnNoError() throws {
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
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
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
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
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
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
    
    func testSetSampleBuffer() throws {
        
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCaptureDevice: mockDevice, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, photoLibrary: mockPhotoLibrary)
        
        let mockDelegate = MockCaptureVideoDataOutputSampleBufferDelegate()
        
        let queue = DispatchQueue.global(qos: .default)
        
        sut.setSampleBufferDelegate(mockDelegate, queue: queue)
        
        XCTAssertIdentical(mockDelegate, mockVideoOutput.sampleBufferDelegateSet as? AnyObject)
        XCTAssertIdentical(queue, mockVideoOutput.queueSet)
    }
}

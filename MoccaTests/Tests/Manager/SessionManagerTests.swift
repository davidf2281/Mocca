//
//  DeviceSessionManagerTests.swift
//  MoccaTests
//
//  Created by David Fearon on 17/10/2020.
//

import XCTest
import AVFoundation

@testable import Mocca

class SessionManagerTests: XCTestCase {
    
    var mockCaptureSession: MockCaptureSession!
    var mockPhotoOutput: MockCapturePhotoOutput!
    var mockVideoOutput: MockVideoOutput!
    var mockDevice:  MockCaptureDevice!
    var mockResources: MockResources!
    var mockPreviewLayer: MockCaptureVideoPreviewLayer!
    var mockPhotoLibrary: MockPhotoLibrary!
    var mockInput: MockCaptureDeviceInput!
    var mockConfigurationFactory: MockConfigurationFactory!
    var mockPhysicalCamera: PhysicalCamera!
    var mockSampleBufferDelegate: MockSampleBufferDelegate!
    var mockDispatchQueue: DispatchQueue!
    
    override func setUp() {
        mockCaptureSession = MockCaptureSession()
        mockPhotoOutput = MockCapturePhotoOutput()
        mockVideoOutput = MockVideoOutput()
        mockDevice =  MockCaptureDevice()
        mockResources = MockResources()
        mockPreviewLayer = MockCaptureVideoPreviewLayer()
        mockPhotoLibrary = MockPhotoLibrary()
        mockInput = MockCaptureDeviceInput()
        mockConfigurationFactory = MockConfigurationFactory()
        mockPhysicalCamera = PhysicalCamera(id: UUID(), type: .builtInTelephotoCamera, position: .back, captureDevice: mockDevice)
        mockSampleBufferDelegate = MockSampleBufferDelegate()
        mockDispatchQueue = DispatchQueue.global(qos: .default)
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
        
        _ = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
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
            _ = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        } catch SessionManagerError.addVideoInputFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testManagerInitializesCaptureSessionWithAddVideoOutputFailure() {

        mockCaptureSession.canAddVideoOutputResponse = false
        
        do {
            _ = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        } catch SessionManagerError.addVideoDataOutputFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testManagerConvenienceInitializesCaptureSession() {

#if targetEnvironment(simulator)
        do {
            _ = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        } catch SessionManagerError.captureDeviceNotFound {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
#else
        do {
            _ = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        } catch {
            XCTFail("Convenience init should not fail on physical device")
        }
#endif
    }
    
    func testManagerInitializesCaptureSessionWithAddOutputFailure() {
        
        mockCaptureSession.canAddPhotoOutputResponse = false
        
        do {
            _ = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        } catch SessionManagerError.addPhotoOutputFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testStartSession() throws {
        
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        sut.startCaptureSession()
        XCTAssertTrue(mockCaptureSession.startRunningCalled)
    }
    
    func testStopSession() throws {
        
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        
        sut.stopCaptureSession()
        XCTAssertTrue(mockCaptureSession.stopRunningCalled)
    }
    
    func testSuccessfulSelectionOfDeviceCamera() throws {
        
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        let camera = PhysicalCamera(id: UUID(), type: .builtInTelephotoCamera, position: .back, captureDevice: MockCaptureDevice())
        
        mockResources.availablePhysicalCameras = [camera]
        
        // TODO: Next: activeCaptureDevice probably no longer needs to be exposed
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === mockDevice)
        
        let result = sut.selectCamera(cameraID: camera.id)
        guard case .success = result else {
            XCTFail()
            return
        }
        
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === camera.captureDevice)
    }
    
    func testUnsuccessfulSelectionOfDeviceCamera() throws {
        
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        let camera = PhysicalCamera(id: UUID(), type: .builtInTelephotoCamera, position: .back, captureDevice: MockCaptureDevice())
        mockResources.availablePhysicalCameras = []

        let newMockDevice = MockCaptureDevice()
        
        mockResources.deviceToReturn = newMockDevice
        mockResources.physicalDeviceCallShouldSucceed = false
        
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === mockDevice)
        
        let result = sut.selectCamera(cameraID: camera.id)
        guard case .failure(.captureDeviceNotFound) = result else {
            XCTFail()
            return
        }
        
        // Check originally selected camera is still selected
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === mockDevice)
    }
    
    func testUnsuccessfulSelectionOfDeviceCameraWithAddVideoInputFail() throws {
        
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        let camera = PhysicalCamera(id: UUID(), type: .builtInTelephotoCamera, position: .back, captureDevice: MockCaptureDevice())
        mockResources.availablePhysicalCameras = [camera]

        let newMockDevice = MockCaptureDevice()
        
        mockResources.deviceToReturn = newMockDevice
        mockResources.physicalDeviceCallShouldSucceed = true
        mockCaptureSession.canAddInputResponse = false
        
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === mockDevice)
        
        let result = sut.selectCamera(cameraID: camera.id)
        guard case .failure(.addVideoInputFailed) = result else {
            XCTFail()
            return
        }
        
        // Check originally selected camera is still selected
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === mockDevice)
    }
    
    func testUnsuccessfulSelectionOfDeviceCameraWithGetVideoInputThrowing() throws {
        
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        let camera = PhysicalCamera(id: UUID(), type: .builtInTelephotoCamera, position: .back, captureDevice: MockCaptureDevice())
        mockResources.availablePhysicalCameras = [camera]
        let newMockDevice = MockCaptureDevice()
        
        mockResources.deviceToReturn = newMockDevice
        mockResources.physicalDeviceCallShouldSucceed = true
        mockCaptureSession.canAddInputResponse = true
        mockConfigurationFactory.videoInputShouldThrow = true
        
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === mockDevice)
        
        let result = sut.selectCamera(cameraID: camera.id)
        guard case .failure(.addVideoInputFailed) = result else {
            XCTFail()
            return
        }
        
        // Check originally selected camera is still selected
        XCTAssert(sut.activeCaptureDevice as! MockCaptureDevice === mockDevice)
    }
    
    // TODO: Consider whether we still need any sort of samplebufferdelegate test
    /*
    func testSetSampleBuffer() throws {
        
        let sut = try SessionManager(captureSession: mockCaptureSession, photoOutput: mockPhotoOutput, videoOutput: mockVideoOutput, initialCamera: mockPhysicalCamera, videoInput: mockInput, resources: mockResources, videoPreviewLayer: mockPreviewLayer, configurationFactory: mockConfigurationFactory, sampleBufferDelegate: mockSampleBufferDelegate, sampleBufferQueue: mockDispatchQueue)
        
        let mockDelegate = MockCaptureVideoDataOutputSampleBufferDelegate()
        
        let queue = DispatchQueue.global(qos: .default)
        
        sut.setSampleBufferDelegate(mockDelegate, queue: queue)
        
        XCTAssertIdentical(mockDelegate, mockVideoOutput.sampleBufferDelegateSet as? AnyObject)
        XCTAssertIdentical(queue, mockVideoOutput.queueSet)
    }
     */
}

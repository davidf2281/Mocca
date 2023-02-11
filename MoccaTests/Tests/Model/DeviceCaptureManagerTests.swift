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

    var mockCaptureSession: MockAVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var videoDataOutput: AVCaptureVideoDataOutput!
    var mockDevice:  MockAVCaptureDevice!
    var mockResources: MockResources!

    // MARK: TODO Investigate why using UnavailableInitFactory.instanceOfAVCaptureDeviceInput() works when used in function scope but not at property level.
    
    override func setUp() {
         mockCaptureSession = MockAVCaptureSession()
         photoOutput =  AVCapturePhotoOutput()
         videoDataOutput = AVCaptureVideoDataOutput()
         mockDevice =  MockAVCaptureDevice()
         mockResources = MockResources()
    }

    func testInitialTestConditions() {
        // Initial conditions
        let input = UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        XCTAssertTrue(mockCaptureSession.canAddInput(input))
        XCTAssertTrue(mockCaptureSession.canAddOutputResponse)
        
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
        let input = UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        _ = try CaptureManager(captureSession: mockCaptureSession, photoOutput: photoOutput, videoOutput: videoDataOutput, initialCaptureDevice: mockDevice, videoInput: input, resources: mockResources)
        
        XCTAssertTrue(mockCaptureSession.beginConfigirationCalled)
        
        XCTAssertTrue(mockCaptureSession.addInputCalled)
        XCTAssertTrue(mockCaptureSession.lastAddedInput === input)

        XCTAssertTrue(mockCaptureSession.addOuputCalled)
        XCTAssertTrue(mockCaptureSession.lastAddedOutput === videoDataOutput)

        XCTAssertTrue(mockCaptureSession.commitConfigurationCalled)
        
        XCTAssertFalse(mockCaptureSession.beginConfigurationNotCalledWhenRequired)
        XCTAssertFalse(mockCaptureSession.commitConfigurationCalledPrematurely)
    }
    
    func testManagerInitializesCaptureSessionWithAddInputFailure() {
        let input = UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        mockCaptureSession.canAddInputResponse = false
        
        do {
            _ = try CaptureManager(captureSession: mockCaptureSession, photoOutput: photoOutput, videoOutput: videoDataOutput, initialCaptureDevice: mockDevice, videoInput: input, resources: mockResources)
        } catch CaptureManagerError.addVideoInputFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    func testManagerConvenienceInitializesCaptureSession() {

        #if targetEnvironment(simulator)
        do {
            _ = try CaptureManager(resources: MockResources())
        } catch CaptureManagerError.captureDeviceNotFound {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
        #else
        do {
            _ = try CaptureManager(resources: DeviceResources.shared)
        } catch {
            XCTFail("Convenience init should not fail on physical device")
        }
        #endif
    }
    
    func testManagerInitializesCaptureSessionWithAddOutputFailure() {
        let input = UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        mockCaptureSession.canAddOutputResponse = false
        
        do {
            _ = try CaptureManager(captureSession: mockCaptureSession, photoOutput: photoOutput, videoOutput: videoDataOutput, initialCaptureDevice: mockDevice, videoInput: input, resources: mockResources)
        } catch CaptureManagerError.addPhotoOutputFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testStartSession() throws {
        let input = UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: photoOutput, videoOutput: videoDataOutput, initialCaptureDevice: mockDevice, videoInput: input, resources: mockResources)

        
        sut.startCaptureSession()
        XCTAssertTrue(mockCaptureSession.startRunningCalled)
    }
    
    func testStopSession() throws {
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: photoOutput, videoOutput: videoDataOutput, initialCaptureDevice: mockDevice, videoInput: input, resources: mockResources)

        
        sut.stopCaptureSession()
        XCTAssertTrue(mockCaptureSession.stopRunningCalled)
    }
    
    func testConfiguredPhotoOutput() {
        let photoOutput = CaptureManager.configuredPhotoOutput()
        XCTAssert(photoOutput.isHighResolutionCaptureEnabled == true)
        XCTAssert(photoOutput.maxPhotoQualityPrioritization == .quality)
        XCTAssert(photoOutput.isLivePhotoCaptureEnabled == false)
        XCTAssert(photoOutput.isDepthDataDeliveryEnabled == false)
        XCTAssert(photoOutput.isPortraitEffectsMatteDeliveryEnabled == false)
        XCTAssert(photoOutput.isVirtualDeviceConstituentPhotoDeliveryEnabled == false)
    }
    
    func testConfiguredPhotoSettings() {
        let photoOutput = CaptureManager.configuredPhotoOutput()
        let photoSettings = CaptureManager.configuredPhotoSettings(for: photoOutput)
        XCTAssert(photoSettings.photoQualityPrioritization == .quality)
        XCTAssert(photoSettings.flashMode == .off)
    }
    
    // AVCapturePhotoSettings documentation states:
    // "It is illegal to reuse a AVCapturePhotoSettings instance for multiple captures."
    func testCurrentPhotoSettingsReturnsUniqueSettingsObject() throws {
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: photoOutput, videoOutput: videoDataOutput, initialCaptureDevice: mockDevice, videoInput: input, resources: mockResources)


        let settingsA = sut.currentPhotoSettings()
        let settingsB = sut.currentPhotoSettings()
        
        XCTAssert(settingsA !== settingsB)
    }
    
    func testSuccessfulSelectionOfDeviceCamera() throws {
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()
        
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: photoOutput, videoOutput: videoDataOutput, initialCaptureDevice: mockDevice, videoInput: input, resources: mockResources)

        let logicalDevice = LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back)
        let newMockDevice = MockAVCaptureDevice()
        
        mockResources.deviceToReturn = newMockDevice
        
        XCTAssert(sut.activeCaptureDevice as! MockAVCaptureDevice === mockDevice)
        
        let result = sut.selectCamera(type: logicalDevice)
        guard case .success = result else {
            XCTFail()
            return
        }
        
        XCTAssert(sut.activeCaptureDevice as! MockAVCaptureDevice === newMockDevice)
    }
    
    func testUnsuccessfulSelectionOfDeviceCamera() throws {
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()
        
        let sut = try CaptureManager(captureSession: mockCaptureSession, photoOutput: photoOutput, videoOutput: videoDataOutput, initialCaptureDevice: mockDevice, videoInput: input, resources: mockResources)

        
        let logicalDevice = LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back)
        let newMockDevice = MockAVCaptureDevice()
        
        mockResources.deviceToReturn = newMockDevice
        mockResources.physicalDeviceCallShouldSucceed = false
        
        XCTAssert(sut.activeCaptureDevice as! MockAVCaptureDevice === mockDevice)
        
        let result = sut.selectCamera(type: logicalDevice)
        guard case .failure(.captureDeviceNotFound) = result else {
            XCTFail()
            return
        }
        
        // Check originally selected camera is still selected
        XCTAssert(sut.activeCaptureDevice as! MockAVCaptureDevice === mockDevice)
    }
    
//    func testCapturePhoto () throws {
//        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()
//
//        let sut = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)
//
//        let settings = AVCapturePhotoSettings()
//        let taker = DevicePhotoTaker(captureManager: sut, photoLibrary: MockPHPhotoLibrary())
//
//        XCTAssert(output.capturePhotoCalled == false)
//        XCTAssertNil(output.lastphotoCaptureSettings)
//
//        sut.capturePhoto(settings: settings, delegate: taker)
//        XCTAssert(output.capturePhotoCalled == true)
//        XCTAssert(output.lastphotoCaptureSettings === settings)
//    }
}

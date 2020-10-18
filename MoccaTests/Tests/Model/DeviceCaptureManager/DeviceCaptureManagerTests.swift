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

    var session: MockAVCaptureSession!
    var output:  MockAVCapturePhotoOutput!
    var device:  MockAVCaptureDevice!

    // MARK: TODO Investigate why using UnavailableInitFactory.instanceOfAVCaptureDeviceInput() works when used in function scope but not at property level.
    
    override func setUp() {
         session = MockAVCaptureSession()
         output =  MockAVCapturePhotoOutput()
         device =  MockAVCaptureDevice()
    }

    func testInitialTestConditions() {
        // Initial conditions
        let input = UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        XCTAssertTrue(session.canAddInput(input))
        XCTAssertTrue(session.canAddOutputResponse)
        
        XCTAssertNil(session.lastAddedInput)
        XCTAssertNil(session.lastAddedOutout)
        
        XCTAssertFalse(session.beginConfigirationCalled)
        XCTAssertFalse(session.addInputCalled)
        XCTAssertFalse(session.addOuputCalled)
        XCTAssertFalse(session.commitConfigurationCalled)
        XCTAssertFalse(session.startRunningCalled)
        XCTAssertFalse(session.stopRunningCalled)
        XCTAssertFalse(session.beginConfigurationNotCalledWhenRequired)
        XCTAssertFalse(session.commitConfigurationCalledPrematurely)
    }
    
    func testManagerInitializesCaptureSession() throws {
        let input = UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        _ = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)
        
        XCTAssertTrue(session.beginConfigirationCalled)
        
        XCTAssertTrue(session.addInputCalled)
        XCTAssertTrue(session.lastAddedInput === input)

        XCTAssertTrue(session.addOuputCalled)
        XCTAssertTrue(session.lastAddedOutout === output)

        XCTAssertTrue(session.commitConfigurationCalled)
        
        XCTAssertFalse(session.beginConfigurationNotCalledWhenRequired)
        XCTAssertFalse(session.commitConfigurationCalledPrematurely)
    }
    
    func testManagerInitializesCaptureSessionWithAddInputFailure() {
        let input = UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        session.canAddInputResponse = false
        
        do {
            _ = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)
        } catch CaptureManagerError.addVideoInputFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    func testManagerConvenienceInitializesCaptureSession() {

        #if targetEnvironment(simulator)
        do {
            _ = try DeviceCaptureManager()
        } catch CaptureManagerError.captureDeviceNotFound {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
        #else
        do {
            _ = try DeviceCaptureManager()
        } catch {
            XCTFail("Convenience init should not fail on physical device")
        }
        #endif
    }
    
    func testManagerInitializesCaptureSessionWithAddOutputFailure() {
        let input = UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        session.canAddOutputResponse = false
        
        do {
            _ = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)
        } catch CaptureManagerError.addVideoOutputFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testStartSession() throws {
        let input = UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        let sut = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)
        
        sut.startCaptureSession()
        XCTAssertTrue(session.startRunningCalled)
    }
    
    func testStopSession() throws {
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        let sut = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)
        
        sut.stopCaptureSession()
        XCTAssertTrue(session.stopRunningCalled)
    }
    
    func testConfiguredPhotoOutput() {
        let photoOutput = DeviceCaptureManager.configuredPhotoOutput()
        XCTAssert(photoOutput.isHighResolutionCaptureEnabled == true)
        XCTAssert(photoOutput.maxPhotoQualityPrioritization == .quality)
        XCTAssert(photoOutput.isLivePhotoCaptureEnabled == false)
        XCTAssert(photoOutput.isDepthDataDeliveryEnabled == false)
        XCTAssert(photoOutput.isPortraitEffectsMatteDeliveryEnabled == false)
        XCTAssert(photoOutput.isVirtualDeviceConstituentPhotoDeliveryEnabled == false)
    }
    
    func testConfiguredPhotoSettings() {
        let photoOutput = DeviceCaptureManager.configuredPhotoOutput()
        let photoSettings = DeviceCaptureManager.configuredPhotoSettings(for: photoOutput)
        XCTAssert(photoSettings.photoQualityPrioritization == .quality)
        XCTAssert(photoSettings.flashMode == .off)
    }
    
    // AVCapturePhotoSettings documentation states:
    // "It is illegal to reuse a AVCapturePhotoSettings instance for multiple captures."
    func testCurrentPhotoSettingsReturnsUniqueSettingsObject() throws {
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()
        let sut = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)

        let settingsA = sut.currentPhotoSettings()
        let settingsB = sut.currentPhotoSettings()
        
        XCTAssert(settingsA !== settingsB)
    }
    
    func testCapturePhoto () throws {
        let input =   UnavailableInitFactory.instanceOfAVCaptureDeviceInput()

        let sut = try DeviceCaptureManager(captureSession: session, output: output, initialCaptureDevice: device, videoInput: input)
        
        let settings = AVCapturePhotoSettings()
        let taker = DevicePhotoTaker(captureManager: sut, photoLibrary: MockPHPhotoLibrary())
        
        XCTAssert(output.capturePhotoCalled == false)
        XCTAssertNil(output.lastphotoCaptureSettings)
        
        sut.capturePhoto(settings: settings, delegate: taker)
        XCTAssert(output.capturePhotoCalled == true)
        XCTAssert(output.lastphotoCaptureSettings === settings)
    }
}

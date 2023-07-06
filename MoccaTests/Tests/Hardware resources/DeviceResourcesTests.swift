//
//  ConfigurationFactoryTests.swift
//  MoccaTests
//
//  Created by David Fearon on 30/06/2023.
//

import XCTest
@testable import Mocca

final class DeviceResourcesTests: XCTestCase {
    
    var sut: DeviceResources!
    var mockCaptureDevice: MockCaptureDevice!
    
    override func setUpWithError() throws {
        mockCaptureDevice = MockCaptureDevice()
    }

    func testPhysicalDeviceFromLogicalDevice() throws {
                        
        let sut = DeviceResources(captureDevice: mockCaptureDevice, supportedCameraDevices: [])!

        let logicalCameraDevice = LogicalCameraDevice(type: .builtInUltraWideCamera, position: .front)
        
        let _ = sut.physicalDevice(from: logicalCameraDevice)
        
        XCTAssertEqual(mockCaptureDevice.positionSet, .front)
        XCTAssertEqual(mockCaptureDevice.deviceTypeSet, .builtInUltraWideCamera)
    }
    
    func testAnyAvailableCameraWhenPreferredDeviceAvailable() throws {
        let supportedCameraDevices = [
            LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back),
            LogicalCameraDevice(type: .builtInWideAngleCamera, position: .back),
            LogicalCameraDevice(type: .builtInUltraWideCamera, position: .back)
        ]
        
        let sut = DeviceResources(captureDevice: mockCaptureDevice, supportedCameraDevices: supportedCameraDevices)!

        let preferredDevice = LogicalCameraDevice(type: .builtInWideAngleCamera, position: .back)
        
        mockCaptureDevice.captureDeviceToReturn = mockCaptureDevice

        let result = sut.anyAvailableCamera(preferredDevice: preferredDevice)
        
        XCTAssertEqual(mockCaptureDevice.positionSet, .back)
        XCTAssertEqual(mockCaptureDevice.deviceTypeSet, .builtInWideAngleCamera)
        XCTAssertIdentical(result, mockCaptureDevice)
    }
    
    func testAnyAvailableCameraWhenPreferredDeviceNotAvailable() throws {
        let supportedCameraDevices = [
            LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back),
            LogicalCameraDevice(type: .builtInUltraWideCamera, position: .back)
        ]
        
        let sut = DeviceResources(captureDevice: mockCaptureDevice, supportedCameraDevices: supportedCameraDevices)!

        let preferredDevice = LogicalCameraDevice(type: .builtInWideAngleCamera, position: .back)
                
        mockCaptureDevice.captureDeviceToReturn = mockCaptureDevice

        let _ = sut.anyAvailableCamera(preferredDevice: preferredDevice)
        
        XCTAssertEqual(mockCaptureDevice.positionSet, .back)
        XCTAssertEqual(mockCaptureDevice.deviceTypeSet, .builtInTelephotoCamera)
    }
    
    func testAnyAvailableCameraWhenNoSupportedDevicesAvailable() throws {
        let supportedCameraDevices = [
            LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back),
            LogicalCameraDevice(type: .builtInUltraWideCamera, position: .back)
        ]
        
        let sut = DeviceResources(captureDevice: mockCaptureDevice, supportedCameraDevices: supportedCameraDevices)!

        let preferredDevice = LogicalCameraDevice(type: .builtInWideAngleCamera, position: .back)
                
        mockCaptureDevice.captureDeviceToReturn = nil

        let result = sut.anyAvailableCamera(preferredDevice: preferredDevice)
        
        XCTAssertNil(result)
    }
}

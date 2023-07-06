//
//  MockConfigurationFactory.swift
//  MoccaTests
//
//  Created by David Fearon on 06/07/2023.
//

import Foundation
@testable import Mocca

class MockConfigurationFactory: ConfigurationFactoryContract {
    var supportedCameraDevices: [LogicalCameraDevice] = []
    
    func captureManagerInitializerConfiguration(resources: DeviceResourcesContract, videoPreviewLayer: CaptureVideoPreviewLayer?, captureSession: CaptureSession, captureDeviceInputType: CaptureDeviceInput.Type, photoOutputType: CapturePhotoOutput.Type) throws -> CaptureManagerConfiguration {
        throw(TestError.fail)
    }
    
    func uniquePhotoSettings(device: CaptureDevice, photoOutput: CapturePhotoOutput) -> CapturePhotoSettings {
        return MockPhotoSettings()
    }
    
    func videoInput(for device: CaptureDevice) throws -> CaptureDeviceInput {
        return MockCaptureDeviceInput()
    }
    
    
}

enum TestError: Error {
    case fail
}

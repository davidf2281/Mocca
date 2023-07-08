//
//  ConfigurationFactoryTests.swift
//  MoccaTests
//
//  Created by David Fearon on 30/06/2023.
//

import XCTest
import AVFoundation

final class ConfigurationFactoryTests: XCTestCase {
    
    func testSessionManagerInitializerConfiguration() throws {
        let resources = MockResources()
        resources.deviceToReturn = MockCaptureDevice()
        let videoPreviewLayer = MockCaptureVideoPreviewLayer()
        let captureSessionType = MockCaptureSession()
        let captureDeviceInputType = MockCaptureDeviceInput.self
        let photoOutputType = MockCapturePhotoOutput.self
        let configurationFactory = ConfigurationFactory(captureDeviceInputType: AVCaptureDeviceInput.self)
        let sut = try configurationFactory.sessionManagerInitializerConfiguration(resources: resources, videoPreviewLayer: videoPreviewLayer, captureSession: captureSessionType, captureDeviceInputType: captureDeviceInputType, photoOutputType: photoOutputType)
        
        XCTAssertEqual(sut.captureSession.preset, .photo)
        XCTAssertEqual(sut.photoOutput.livePhotoCaptureEnabled, false)
        XCTAssertEqual(sut.photoOutput.maxQualityPrioritization, .quality)
    }
    
    func testUniquePhotoSettings() {
        
        let configurationFactory = ConfigurationFactory(captureDeviceInputType: AVCaptureDeviceInput.self)

        let sut = configurationFactory.uniquePhotoSettings(device: MockCaptureDevice(), photoOutput: MockCapturePhotoOutput())
        
        XCTAssertEqual(sut.photoFlashMode, .off)
        XCTAssertEqual(sut.qualityPrioritization, .quality)
        XCTAssertEqual(sut.maximumPhotoDimensions, CMVideoDimensions(width: 3000, height: 2000))
    }
}

extension CMVideoDimensions: Equatable {
    public static func == (lhs: CMVideoDimensions, rhs: CMVideoDimensions) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
}

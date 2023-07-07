//
//  ConfigurationFactory.swift
//  Mocca
//
//  Created by David Fearon on 27/06/2023.
//

import Foundation
import AVFoundation

struct CaptureManagerConfiguration {
    let captureSession: CaptureSession
    let photoOutput: CapturePhotoOutput
    let videoOutput: CaptureVideoOutput
    let initialCamera: PhysicalCamera
    let videoInput: CaptureDeviceInput
    let resources: DeviceResourcesContract
    let videoPreviewLayer: CaptureVideoPreviewLayer
    let photoLibrary: PhotoLibrary
}

protocol ConfigurationFactoryContract {
    var supportedLogicalCameras: [LogicalCamera] { get }
    func captureManagerInitializerConfiguration(
        resources: DeviceResourcesContract,
        videoPreviewLayer: CaptureVideoPreviewLayer?,
        captureSession: CaptureSession,
        captureDeviceInputType: CaptureDeviceInput.Type,
        photoOutputType: CapturePhotoOutput.Type
    ) throws -> CaptureManagerConfiguration
    func uniquePhotoSettings(device: CaptureDevice, photoOutput: CapturePhotoOutput) -> CapturePhotoSettings
    func videoInput(for device: CaptureDevice) throws -> CaptureDeviceInput
}

enum ConfigurationFactoryError: Error {
    case captureDeviceNotFound
    case videoPreviewLayerNil
    case getVideoInputFailed
}

struct ConfigurationFactory: ConfigurationFactoryContract {
    
    let captureDeviceInputType: CaptureDeviceInput.Type
    
    init(captureDeviceInputType: CaptureDeviceInput.Type) {
        self.captureDeviceInputType = captureDeviceInputType
    }
    
    func captureManagerInitializerConfiguration(
        resources: DeviceResourcesContract,
        videoPreviewLayer: CaptureVideoPreviewLayer?,
        captureSession: CaptureSession,
        captureDeviceInputType: CaptureDeviceInput.Type,
        photoOutputType: CapturePhotoOutput.Type
    ) throws -> CaptureManagerConfiguration {
        
        let preferredStartupCamera = LogicalCamera(type: .builtInWideAngleCamera, position: .back)
        
        guard let initialCaptureDevice =
                resources.anyAvailableCamera(preferredDevice: preferredStartupCamera)
        else {
            throw CaptureManagerConfigError.captureDeviceNotFound
        }
        
        guard let initialCamera = resources.availablePhysicalCameras.first(where: { $0.type == initialCaptureDevice.captureDeviceType }) else {
            throw CaptureManagerConfigError.captureDeviceNotFound
        }
        
        let captureDeviceInput = try captureDeviceInputType.make(device: initialCaptureDevice)
        
        guard let videoPreviewLayer else {
            throw CaptureManagerConfigError.videoPreviewLayerNil
        }
                
        captureSession.preset = .photo
        let photoOutput = ConfigurationFactory.configuredPhotoOutput(photoOutputType: photoOutputType)
        let videoOutput = ConfigurationFactory.configuredVideoDataOutput()
        let photoLibrary = DevicePhotoLibrary()
                        
        return CaptureManagerConfiguration(captureSession: captureSession, photoOutput: photoOutput, videoOutput: videoOutput, initialCamera: initialCamera, videoInput: captureDeviceInput, resources: resources, videoPreviewLayer: videoPreviewLayer, photoLibrary: photoLibrary)
    }
    
    var supportedLogicalCameras: [LogicalCamera] {
        [LogicalCamera(type: .builtInTelephotoCamera, position: .back),
         LogicalCamera(type: .builtInWideAngleCamera, position: .back),
         LogicalCamera(type: .builtInUltraWideCamera, position: .back)]
    }
    
    func uniquePhotoSettings(device: CaptureDevice, photoOutput: CapturePhotoOutput) -> CapturePhotoSettings {
        let settings = Self.configuredPhotoSettings(device: device, photoOutput: photoOutput)
        return settings
    }
    
    func videoInput(for device: CaptureDevice) throws -> CaptureDeviceInput {
        let videoInput = try self.captureDeviceInputType.make(device: device)
        return videoInput
    }
    
    private static func configuredPhotoSettings(device: CaptureDevice, photoOutput: CapturePhotoOutput) -> CapturePhotoSettings {
        
        let maxDimensions = Self.largestDimensions(from: device.activeFormat.maxPhotoDimensions)

        let settings = photoOutput.availablePhotoCodecs.contains(.hevc) ?
            AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.hevc]) :
            AVCapturePhotoSettings()
        
        settings.maximumPhotoDimensions = maxDimensions
        settings.qualityPrioritization = .quality
        settings.photoFlashMode = .off
        
        return settings
    }
    
    private static func configuredPhotoOutput(photoOutputType: CapturePhotoOutput.Type) -> CapturePhotoOutput {
        let photoOutput = photoOutputType.init()
        photoOutput.livePhotoCaptureEnabled = false
        photoOutput.maxQualityPrioritization = .quality
        return photoOutput
    }
    
    private static func largestDimensions(from dimensions: [CMVideoDimensions]) -> CMVideoDimensions {
        guard let largest = dimensions.first else {
            assert(false)
            return .init(width: 0, height: 0)
        }
        
        return dimensions.reduce(largest) { partialResult, next in
            return next.width * next.height > partialResult.width * partialResult.height ? next : partialResult
        }
    }
    
    private static func configuredVideoDataOutput() -> CaptureVideoOutput {
        let videoDataOutput = AVCaptureVideoDataOutput()
        // TODO: We mustn't assume 32BGRA pixel format is always available
        videoDataOutput.videoSettings = [ String(kCVPixelBufferPixelFormatTypeKey) : kCVPixelFormatType_32BGRA]
        return videoDataOutput
    }
}

//
//  AVCaptureDevice-TestableExtensions.swift
//  Mocca
//
//  Created by David Fearon on 12/02/2023.
//

import Foundation
import AVFoundation

protocol CaptureDevice: AnyObject {
    var iso: Float { get }
    var activeFormat: CaptureDeviceFormat { get set }
    var formats: [CaptureDeviceFormat] { get }
    var activeVideoMinFrameDuration: CMTime { get set }
    var exposureDuration: CMTime { get }
    var exposureTargetBias: Float { get }
    var maxExposureTargetBias: Float { get }
    var minExposureTargetBias: Float { get }
    var isExposurePointOfInterestSupported: Bool { get }
    var exposurePointOfInterest: CGPoint { get set }
    var exposureMode: AVCaptureDevice.ExposureMode { get set }
    var focusPointOfInterest: CGPoint { get set }
    var focusMode: AVCaptureDevice.FocusMode { get set }
    func setFocusModeLocked(lensPosition: Float, completionHandler handler: ((CMTime) -> Void)?)
    func setExposureModeCustom(duration: CMTime, iso ISO: Float, completionHandler handler: ((CMTime) -> Void)?)
    func setExposureTargetBias(_ bias: Float, completionHandler handler: ((CMTime) -> Void)?)
    func lockForConfiguration() throws
    func unlockForConfiguration()
    
    var captureDeviceType: CaptureDeviceType { get }
    var captureDevicePosition: CaptureDevicePosition { get }
    func captureDevice(withType deviceType: CaptureDeviceType, position: CaptureDevicePosition) -> CaptureDevice?
    func availablePhysicalDevices(for logicalCameraDevices: [LogicalCamera]) -> [CaptureDevice]
}

protocol AVCaptureDevicePropertyUnshadowing {
    var activeFormat: AVCaptureDevice.Format { get set }
    var formats: [AVCaptureDevice.Format] { get }
}

extension AVCaptureDevice: CaptureDevice {
    var captureDeviceType: CaptureDeviceType {
        switch self.deviceType {
            case .builtInWideAngleCamera:
                return .builtInWideAngleCamera
            case .builtInUltraWideCamera:
                return .builtInUltraWideCamera
            case .builtInTelephotoCamera:
                return .builtInTelephotoCamera
            case .builtInDualCamera:
                return .builtInDualCamera
            case .builtInDualWideCamera:
                return .builtInDualWideCamera
            case .builtInTripleCamera:
                return .builtInTripleCamera
            default:
                return .unsupported
        }
    }
    
    var captureDevicePosition: CaptureDevicePosition {
        switch self.position {
            case .back:
                return .back
            default:
                assert(false)
                return .unsupported
        }
    }
}

extension AVCaptureDevice: AVCaptureDevicePropertyUnshadowing {}

extension CaptureDevice {
    private var realDevice: AVCaptureDevicePropertyUnshadowing? { self as? AVCaptureDevice }
    
    var activeFormat: CaptureDeviceFormat {
        get {
            guard let realDevice else {
                fatalError()
            }
            return realDevice.activeFormat
        }
        
        set {
            if let newValue = newValue as? AVCaptureDevice.Format, var realDevice {
                realDevice.activeFormat = newValue
            }
        }
    }
    
    var formats: [CaptureDeviceFormat] {
        guard let realDevice else {
            fatalError()
        }
        
        return realDevice.formats
    }
}

extension AVCaptureDevice {
    var shadowDeviceType: CaptureDeviceType {
        switch self.deviceType {
            case .builtInWideAngleCamera:
                return .builtInWideAngleCamera
            case .builtInUltraWideCamera:
                return .builtInUltraWideCamera
            case .builtInTelephotoCamera:
                return .builtInTelephotoCamera
            case .builtInDualCamera:
                return .builtInDualCamera
            case .builtInDualWideCamera:
                return .builtInDualWideCamera
            case .builtInTripleCamera:
                return .builtInTripleCamera
            default:
                return .unsupported
        }
    }
    
    var shadowDevicePosition: CaptureDevicePosition {
        switch self.position {
            case .front:
                return .front
            case .back:
                return .back
            case .unspecified:
                return.unspecified
            default:
                return .unsupported
        }
    }
}

extension AVCaptureDevice {
    func captureDevice(withType deviceType: CaptureDeviceType, position: CaptureDevicePosition) -> CaptureDevice? {
        
        let avDeviceType: AVCaptureDevice.DeviceType
        
        switch deviceType {
            case .builtInWideAngleCamera:
                avDeviceType = .builtInWideAngleCamera
            case .builtInUltraWideCamera:
                avDeviceType = .builtInUltraWideCamera
            case .builtInTelephotoCamera:
                avDeviceType = .builtInTelephotoCamera
            case .builtInDualCamera:
                avDeviceType = .builtInDualCamera
            case .builtInDualWideCamera:
                avDeviceType = .builtInDualWideCamera
            case .builtInTripleCamera:
                avDeviceType = .builtInTripleCamera
            case .unsupported:
                return nil
        }
        
        let avPosition: AVCaptureDevice.Position
                
        switch position {
                
            case .front:
                avPosition = .front
            case .back:
                avPosition = .back
            default:
                assert(false)
                avPosition = .front
        }
        
        let session = Self.DiscoverySession(deviceTypes: [avDeviceType], mediaType: .video, position: avPosition)
        if let device = session.devices.first {
            return device
        }
        
        return nil
    }
    
    func availablePhysicalDevices(for logicalCameraDevices: [LogicalCamera]) -> [CaptureDevice] {
        let avDeviceTypes: [AVCaptureDevice.DeviceType] = logicalCameraDevices.compactMap {
            
            guard $0.position == .back else {
                assert(false)
                return nil
            }
            
            switch $0.type {
                case .builtInWideAngleCamera:
                    return .builtInWideAngleCamera
                case .builtInUltraWideCamera:
                    return .builtInUltraWideCamera
                case .builtInTelephotoCamera:
                    return .builtInTelephotoCamera
                case .builtInDualCamera:
                    return .builtInDualCamera
                case .builtInDualWideCamera:
                    return .builtInDualWideCamera
                case .builtInTripleCamera:
                    return .builtInTripleCamera
                case .unsupported:
                    return nil
            }
        }
        
        let session = Self.DiscoverySession(deviceTypes: avDeviceTypes, mediaType: .video, position: .back)
        return session.devices
    }
}

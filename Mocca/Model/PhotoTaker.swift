//
//  PhotoTaker.swift
//  Mocca
//
//  Created by David Fearon on 04/10/2020.
//

import Foundation
import AVFoundation
import Photos

enum PhotoTakerState {
    case ready
    case capturePending
    case captureError
    case saving
    case saveError
}

protocol PhotoTaker {
    var state: PhotoTakerState { get }
    
    func resetState() -> Outcome
    func takePhoto() -> Outcome
}

class ConcretePhotoTaker: NSObject, PhotoTaker {
    
    @Published fileprivate(set) var state: PhotoTakerState = .ready
    
    public func resetState() -> Outcome {
        self.state = .ready
        return .success
    }
    
    public func takePhoto() -> Outcome { fatalError("Subclasses must override") }
}

/// Communicates with capture manager to kick off capture of a photo, saving the resulting AVCapturePhoto object to device.
class DevicePhotoTaker: ConcretePhotoTaker, AVCapturePhotoCaptureDelegate, ObservableObject  {
    
    private let captureManager: CaptureManager?
    private let photoLibrary:   TestablePHPhotoLibrary
    
    init(captureManager: CaptureManager?, photoLibrary: TestablePHPhotoLibrary) {
        self.captureManager = captureManager
        self.photoLibrary = photoLibrary
    }
        
    public override func takePhoto() -> Outcome {
        if let manager = self.captureManager {
            let settings = manager.currentPhotoSettings()
            manager.capturePhoto(settings: settings, delegate: self)
            self.state = .capturePending
            return .success
        } else {
            self.state = .captureError
            return .failure
        }
    }
    
    // MARK: AVCapturePhotoCaptureDelegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        self.state = ( error == nil ? .saving : .captureError )
        
        // We continue to attempt the save even if an error is returned, since the API contract guarantees |photo|
        // to be non-nil, and we must never throw away a user's photo if there's still a chance the save might succeed
        
        self.photoLibrary.performChanges({
                                            let creationRequest = PHAssetCreationRequest.forAsset()
                                            creationRequest.addResource(with: .photo, data: photo.fileDataRepresentation()!, options: nil)}, completionHandler:{ (success: Bool, error : Error?) -> Void in
                                                self.state = ( success ? .ready : .saveError )
                                            })
    }
}

class MockPhotoTaker: ConcretePhotoTaker, ObservableObject {
    private(set) var takePhotoCalled = false
    override public func takePhoto() -> Outcome {
        self.takePhotoCalled = true
        self.state = .capturePending
        return .success
    }
}

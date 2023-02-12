//
//  PhotoTaker.swift
//  Mocca
//
//  Created by David Fearon on 04/10/2020.
//

import Foundation
import AVFoundation
import Photos

enum PhotoTakerState: Equatable {
    case ready
    case capturePending
    case saving
    case error(_ error: PhotoTakerError)
}

enum PhotoTakerError: Error {
    case captureError
    case saveError
}

protocol PhotoTakerContract {
    var state: PhotoTakerState { get }
    var statePublisher: Published<PhotoTakerState>.Publisher { get }

    func resetState() -> Result<PhotoTakerState, PhotoTakerError>
    func takePhoto() -> Result<PhotoTakerState, PhotoTakerError>
}

class PhotoTaker: NSObject, PhotoTakerContract {
    
    @Published fileprivate(set) var state: PhotoTakerState = .ready
    var statePublisher: Published<PhotoTakerState>.Publisher { $state }
    
    public func resetState() -> Result<PhotoTakerState, PhotoTakerError> {
        self.state = .ready
        return .success(.ready)
    }
    
    public func takePhoto() -> Result<PhotoTakerState, PhotoTakerError> { fatalError("Subclasses must override") }
}

/// Communicates with capture manager to kick off capture of a photo, saving the resulting AVCapturePhoto object to device.
class DevicePhotoTaker: PhotoTaker, AVCapturePhotoCaptureDelegate, ObservableObject  {
    
    private let captureManager: CaptureManagerContract?
    private let photoLibrary:   PHPhotoLibraryContract
    
    init(captureManager: CaptureManagerContract?, photoLibrary: PHPhotoLibraryContract) {
        self.captureManager = captureManager
        self.photoLibrary = photoLibrary
    }
    
    public override func takePhoto() -> Result<PhotoTakerState, PhotoTakerError> {
        if let manager = self.captureManager {
            let settings = manager.currentPhotoSettings()
            manager.capturePhoto(settings: settings, delegate: self)
            let state: PhotoTakerState = .capturePending
            self.state = state
            return .success(state)
        } else {
            self.state = .error(.captureError)
            return .failure(.captureError)
        }
    }
    
    // MARK: AVCapturePhotoCaptureDelegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        self.state = ( error == nil ? .saving : .error(.captureError) )
        
        // We continue to attempt the save even if an error is returned, since the API contract guarantees |photo|
        // to be non-nil, and we must never throw away a user's photo if there's still a chance the save might succeed
        
        self.photoLibrary.performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: photo.fileDataRepresentation()!, options: nil)}, completionHandler:{ (success: Bool, error : Error?) -> Void in
                self.state = ( success ? .ready : .error(.saveError) )
            })
    }
}

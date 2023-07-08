//
//  PhotoCaptureCoordinator.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation

enum PhotoCaptureError: Error {
    case saveFailed
}

enum PhotoCaptureCoordinatorState {
    case ready
    case error(PhotoCaptureError)
}

protocol PhotoCaptureCoordinating: AnyObject {
    var state: PhotoCaptureCoordinatorState { get }
    var statePublisher: Published<PhotoCaptureCoordinatorState>.Publisher { get }
}

class PhotoCaptureCoordinator: PhotoCaptureCoordinating {
    
    @Published private(set) var state: PhotoCaptureCoordinatorState = .ready
    var statePublisher: Published<PhotoCaptureCoordinatorState>.Publisher { $state }
    
    private let captureManager: CaptureManager
    private let photoLibrary: PhotoLibrary
    
    init(captureManager: CaptureManager, photoLibrary: PhotoLibrary) {
        self.captureManager = captureManager
        self.photoLibrary = photoLibrary
    }
}

extension PhotoCaptureCoordinator: CaptureManagerDelegate {
    func didFinishProcessingPhoto(_ photo: CapturePhoto, error: Error?) {
        // We continue to attempt the save even if an error is returned, since the API contract guarantees |photo|
        // to be non-nil, and we must never throw away a user's photo if there's still a chance the save might succeed
        
        self.photoLibrary.addPhoto(photo) { success, error in
            self.state = ( success ? .ready : .error(.saveFailed) )
        }
    }
}

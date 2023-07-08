//
//  CaptureManager.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation

enum CaptureManagerState: Equatable {
    case ready
    case capturePending
    case saving
    case error(_ error: CaptureManagerError)
}

enum CaptureManagerError: Error {
    case captureError
    case saveError
    case resetError
    case unknown
}

protocol CaptureManagerContract: PhotoCaptureIntermediaryDelegate {
    var state: CaptureManagerState { get }
    var statePublisher: Published<CaptureManagerState>.Publisher { get }
    func resetState() -> Result<CaptureManagerState, CaptureManagerError>
    func capturePhoto()
}

protocol CaptureManagerDelegate: AnyObject {
    func didFinishProcessingPhoto(_ photo: CapturePhoto, error: Error?)
}

class CaptureManager: CaptureManagerContract {

    @Published fileprivate(set) var state: CaptureManagerState = .ready
    var statePublisher: Published<CaptureManagerState>.Publisher { $state }

    weak var delegate: CaptureManagerDelegate?
    
    private let photoOutput: CapturePhotoOutput
    private let photoCaptureIntermediary: PhotoCaptureIntermediary
    private let settingsProvider: PhotoSettingsProviding
    
    init(photoOutput: CapturePhotoOutput, photoCaptureIntermediary: PhotoCaptureIntermediary, settingsProvider: PhotoSettingsProviding) {
        self.photoOutput = photoOutput
        self.photoCaptureIntermediary = photoCaptureIntermediary
        self.settingsProvider = settingsProvider
        
        // TODO: Test to make sure delegate is set
        self.photoCaptureIntermediary.delegate = self
    }

    func resetState() -> Result<CaptureManagerState, CaptureManagerError> {
        return .failure(CaptureManagerError.resetError) // TODO: Implement me
    }
    
    func capturePhoto() {
        self.state = .capturePending
        
        if let photoOutputConnection = self.photoOutput.connection() {
            photoOutputConnection.orientation = Orientation.currentInterfaceOrientation()
        }
        
        self.photoOutput.capture(with: self.settingsProvider.uniqueSettings, delegate: self.photoCaptureIntermediary)
    }
}

extension CaptureManager: PhotoCaptureIntermediaryDelegate {
    func didFinishProcessingPhoto(_ photo: CapturePhoto, error: Error?) {
        precondition(self.state == .capturePending)

        self.delegate?.didFinishProcessingPhoto(photo, error: error)
    }
}

//
//  MockPhotoTaker.swift
//  MoccaTests
//
//  Created by David Fearon on 11/02/2023.
//

import Foundation
import Combine
@testable import Mocca

class MockCaptureManager: CaptureManagerContract, ObservableObject {
 
    @Published private(set) var state: CaptureManagerState = .ready
    var statePublisher: Published<CaptureManagerState>.Publisher { $state }
    weak var delegate: CaptureManagerDelegate?

    func resetState() -> Result<CaptureManagerState, CaptureManagerError> {
        self.state = .ready
        return .success(.ready)
    }

    var takePhotoCalledCount = 0
    func capturePhoto() {
        self.state = .capturePending
        takePhotoCalledCount += 1
    }
    
    var photoReceived: CapturePhoto?
    var errorReceived: Error?
    func didFinishProcessingPhoto(_ photo: CapturePhoto, error: Error?) {
        photoReceived = photo
        errorReceived = error
    }
}

    

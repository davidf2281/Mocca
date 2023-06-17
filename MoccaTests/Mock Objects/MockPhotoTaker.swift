//
//  MockPhotoTaker.swift
//  MoccaTests
//
//  Created by David Fearon on 11/02/2023.
//

import Foundation
import Combine
@testable import Mocca

class MockPhotoTaker: PhotoTakerContract, ObservableObject {
    @Published private(set) var state: PhotoTakerState = .ready
    var statePublisher: Published<PhotoTakerState>.Publisher { $state }

    public func resetState() -> Result<PhotoTakerState, PhotoTakerError> {
        self.state = .ready
        return .success(.ready)
    }

    public func takePhoto() -> Result<PhotoTakerState, PhotoTakerError> {
        self.takePhotoCalled = true
        self.state = .capturePending
        return .success(.capturePending)
    }
    
    private(set) var takePhotoCalled = false
}

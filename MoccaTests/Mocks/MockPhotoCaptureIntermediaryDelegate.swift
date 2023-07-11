//
//  MockPhotoCaptureIntermediaryDelegate.swift
//  MoccaTests
//
//  Created by David Fearon on 11/07/2023.
//

import Foundation

class MockPhotoCaptureIntermediaryDelegate: PhotoCaptureIntermediaryDelegate {
    
    var didFinishProcessingPhotoCallCount = 0
    var photoReceived: CapturePhoto?
    var errorReceived: Error?
    func didFinishProcessingPhoto(_ photo: CapturePhoto, error: Error?) {
        photoReceived = photo
        errorReceived = error
        didFinishProcessingPhotoCallCount += 1
    }
}

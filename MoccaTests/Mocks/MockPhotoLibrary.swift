//
//  MockPhotoLibrary.swift
//  MoccaTests
//
//  Created by David Fearon on 05/10/2020.
//

import Foundation
import XCTest
import Dispatch

@testable import Mocca

class MockPhotoLibrary: PhotoLibrary {
    
    // Test vars
    var performChangesCalled = false
    var shouldSucceedOnPerformChanges = true
    
    var addPhotoCallCount = 0
    var photoAdded: CapturePhoto?
    var successToReturn = false
    var errorToReturn: Error? = nil
    func addPhoto(_ photo: CapturePhoto, completion: @escaping (Bool, Error?) -> ()) {
        addPhotoCallCount += 1
        photoAdded = photo
        completion(successToReturn, errorToReturn)
    }
}

class MockPhoto: CapturePhoto {}

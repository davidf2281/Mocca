//
//  MockPHPhotoLibrary.swift
//  MoccaTests
//
//  Created by David Fearon on 05/10/2020.
//

import Foundation
import XCTest
import Dispatch

@testable import Mocca

class MockPHPhotoLibrary: TestablePHPhotoLibrary {
    
    // Test vars
    var performChangesCalled = false
    var shouldSucceedOnPerformChanges = true
    
    func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: ((Bool, Error?) -> Void)?) {
        
        self.performChangesCalled = true
                
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(0.1))) { // Simulate delay while writing image to disk
            if let completion = completionHandler {
                completion(self.shouldSucceedOnPerformChanges, self.shouldSucceedOnPerformChanges ? nil : NSError())
            }
        }
    }
}

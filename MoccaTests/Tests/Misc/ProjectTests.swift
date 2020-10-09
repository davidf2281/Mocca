//
//  ProjectTests.swift
//  MoccaTests
//
//  Created by David Fearon on 07/10/2020.
//

import XCTest
@testable import Mocca
class ProjectTests: XCTestCase {

    func testAppDisplayName() throws {
        let name = System.appDisplayName()
        XCTAssertEqual(name, "Mocca")
    }

    func testBundleCameraUsageDescription() {
        if let message = bundlePlistCameraUsageDescription() {
            XCTAssertEqual(message,
                           "Mocca needs access to your camera so you can take photos!")
        }
    }

    func testBundlePlistPhotoLibraryAddUsageDescription() {
        if let message = bundlePlistPhotoLibraryAddUsageDescription() {
            XCTAssertEqual(message,
                           "Mocca needs to save the photos you take to your photo library.")
        }
    }
    
    private func bundlePlistCameraUsageDescription() -> String? {
        if let dictionary = Bundle.main.infoDictionary {
            return dictionary["NSCameraUsageDescription"] as? String
        }
        
        return nil
    }
    
    private func bundlePlistPhotoLibraryAddUsageDescription() -> String? {
        if let dictionary = Bundle.main.infoDictionary {
            return dictionary["NSPhotoLibraryAddUsageDescription"] as? String
        }
        
        return nil
    }
}

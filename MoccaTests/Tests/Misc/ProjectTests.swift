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
        guard let message = bundlePlistCameraUsageDescription() else { XCTFail(); return }
        
        XCTAssertEqual(message, "Mocca needs access to your camera so you can take photos!")
    }
    
    func testBundlePlistPhotoLibraryAddUsageDescription() {
        guard let message = bundlePlistPhotoLibraryAddUsageDescription() else { XCTFail(); return }
        
        XCTAssertEqual(message, "Mocca needs to save the photos you take to your photo library.")
    }
}

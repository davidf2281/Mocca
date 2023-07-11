//
//  PhotoSettingsProviderTests.swift
//  MoccaTests
//
//  Created by David Fearon on 11/07/2023.
//

import XCTest
@testable import Mocca

final class PhotoSettingsProviderTests: XCTestCase {

    var sut: PhotoSettingsProvider!
    var mockSessionManager: MockSessionManager!
    var mockConfigurationFactory: MockConfigurationFactory!
    
    override func setUpWithError() throws {
        mockSessionManager = MockSessionManager()
        mockConfigurationFactory = MockConfigurationFactory()
        sut = PhotoSettingsProvider(sessionManager: mockSessionManager, configurationProvider: mockConfigurationFactory)
    }

    func testUniqueSettings() throws {
        let settings1 = sut.uniqueSettings
        let settings2 = sut.uniqueSettings
        XCTAssertNotIdentical(settings1, settings2)
    }
    
    func testSettingsOfSettings() {
        let settings = sut.uniqueSettings
        XCTAssertEqual(settings.photoFlashMode, .off)
        XCTAssertEqual(settings.qualityPrioritization, .quality)
    }
}

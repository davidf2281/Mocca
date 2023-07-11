//
//  MockPhotoSettingsProvider.swift
//  MoccaTests
//
//  Created by David Fearon on 11/07/2023.
//

import Foundation

class MockPhotoSettingsProvider: PhotoSettingsProviding {
    var uniqueSettingsToReturn = MockPhotoSettings()
    var uniqueSettings: CapturePhotoSettings {
        return uniqueSettingsToReturn
    }
}

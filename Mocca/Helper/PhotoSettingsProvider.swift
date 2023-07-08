//
//  PhotoSettingsProvider.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation

protocol PhotoSettingsProviding {
    var uniqueSettings: CapturePhotoSettings { get }
}

struct PhotoSettingsProvider: PhotoSettingsProviding {
    
    var uniqueSettings: CapturePhotoSettings {
        self.configurationProvider.uniquePhotoSettings(device: sessionManager.activeCaptureDevice, photoOutput: sessionManager.photoOutput)
    }
    
    private let sessionManager: SessionManagerContract
    private let configurationProvider: ConfigurationFactoryContract
    
    init(sessionManager: SessionManagerContract, configurationProvider: ConfigurationFactoryContract) {
        self.sessionManager = sessionManager
        self.configurationProvider = configurationProvider
    }
}

//
//  Settings.swift
//  Mocca
//
//  Created by David Fearon on 25/09/2020.
//

import Foundation

class UserSettings: ObservableObject {
    
    private static let autoExposureKey = "autoExposureIsOn"
    private static let autoFocusKey =    "autoFocusIsOn"
    private let defaults: UserDefaults

    @Published var autoExposureOn = UserDefaults.standard.bool(forKey: UserSettings.autoExposureKey) {
        didSet {
            defaults.set(self.autoExposureOn, forKey: UserSettings.autoExposureKey)
        }
    }
    
    @Published var autoFocusOn = UserDefaults.standard.bool(forKey: UserSettings.autoFocusKey) {
        didSet {
            defaults.set(self.autoFocusOn, forKey: UserSettings.autoFocusKey)
        }
    }
        
    required init(defaults: UserDefaults) {
        self.defaults = defaults
    }
}

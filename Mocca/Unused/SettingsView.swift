//
//  SettingsView.swift
//  Mocca
//
//  Created by David Fearon on 25/09/2020.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings: UserSettings
    
    /// Initialize the view
    /// - Parameter settings: an instance of Settings
    init(settings: UserSettings) {
        self.settings = settings
    }
    
    var body: some View {
        VStack {
            Text("Settings")
            List {
                Toggle(isOn: $settings.autoExposureOn) {
                    Text("Auto-exposure")
                }
                .padding()
                
                Toggle(isOn: $settings.autoFocusOn) {
                    Text("Auto-focus")
                }
                .padding()
            }
        }
    }
}
 
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings:UserSettings(defaults:UserDefaults.standard))
    }
}

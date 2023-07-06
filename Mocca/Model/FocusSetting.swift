//
//  FocusWidget.swift
//  Mocca
//
//  Created by David Fearon on 27/09/2020.
//

import Foundation
import CoreGraphics

class FocusSetting: CameraSetting {
    typealias Unit = Float64
    var value: Float64 = 0.5
    var settingState = SettingState.active
}

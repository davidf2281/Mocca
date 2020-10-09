//
//  FocusWidget.swift
//  Mocca
//
//  Created by David Fearon on 27/09/2020.
//

import Foundation
import CoreGraphics
import SwiftUI

public class FocusSetting: CameraSetting {
    typealias Unit = Float64
    internal var value: Float64 = 0.5
    var settingState = SettingState.active
}

//
//  ExposureWidget.swift
//  Mocca
//
//  Created by David Fearon on 27/09/2020.
//

import Foundation
import CoreMedia

public class ExposureSetting: CameraSetting {
    typealias Unit = CMTime
    internal var value = CMTimeMakeWithSeconds(1, preferredTimescale: 1)
    var settingState = SettingState.active
}

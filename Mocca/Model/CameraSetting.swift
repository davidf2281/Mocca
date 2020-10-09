//
//  Control.swift
//  Mocca
//
//  Created by David Fearon on 27/09/2020.
//

import Foundation

enum SettingState {
    case active
    case disabled
    case locked
}

protocol CameraSetting {
    associatedtype Unit
    var value : Unit { get }
    var settingState : SettingState { get set }
}

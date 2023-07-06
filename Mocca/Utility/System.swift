//
//  File.swift
//  Mocca
//
//  Created by David Fearon on 07/10/2020.
//

import Foundation

final class System {
    final class func runningInSimulator() -> Bool {
        
        #if !DEBUG // Production builds always return false as an extra layer of safety
        return false
        #elseif targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}

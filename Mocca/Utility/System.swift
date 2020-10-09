//
//  File.swift
//  Mocca
//
//  Created by David Fearon on 07/10/2020.
//

import Foundation

public final class System {
    final class func runningInSimulator() -> Bool {
        
        // Production builds always return false
        // as an extra layer of safety
        #if !DEBUG
        return false
        #endif

        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    final class func appDisplayName() -> String? {
        if let dictionary = Bundle.main.infoDictionary {
            return dictionary["CFBundleDisplayName"] as? String
        }
        
        return nil
    }
}

//
//  File.swift
//  MoccaTests
//
//  Created by David Fearon on 10/10/2020.
//

import Foundation

func bundlePlistCameraUsageDescription() -> String? {
    if let dictionary = Bundle.main.infoDictionary {
        return dictionary["NSCameraUsageDescription"] as? String
    }
    
    return nil
}

func bundlePlistPhotoLibraryAddUsageDescription() -> String? {
    if let dictionary = Bundle.main.infoDictionary {
        return dictionary["NSPhotoLibraryAddUsageDescription"] as? String
    }
    
    return nil
}

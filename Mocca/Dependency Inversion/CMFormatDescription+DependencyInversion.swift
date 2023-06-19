//
//  CMFormatDescription+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation

extension CMFormatDescription: FormatDescription {}

protocol FormatDescription {
    var dimensions: CMVideoDimensions { get }
    var mediaSubType: CMFormatDescription.MediaSubType { get }
}

extension FormatDescription {

    var dimensions: CMVideoDimensions {
        guard let realDescription else {
            fatalError()
        }
        return realDescription.dimensions
    }
    
    var mediaSubType: CMFormatDescription.MediaSubType {
        guard let realDescription else {
            fatalError()
        }
        return realDescription.mediaSubType
    }
    
    private var realDescription: CMFormatDescription? {
        guardedCast(self)
    }
    
    private func guardedCast<T>(_ value: T) -> CMFormatDescription? {
        guard CFGetTypeID(value as CFTypeRef) == CMFormatDescription.self.typeID else {
            return nil
        }
        return (value as! CMFormatDescription)
    }
}

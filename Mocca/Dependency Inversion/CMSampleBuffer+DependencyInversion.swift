//
//  CMSampleBuffer+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation

protocol SampleBuffer: AnyObject {}
extension CMSampleBuffer: SampleBuffer {}

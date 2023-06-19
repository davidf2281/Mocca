//
//  AVCapturePhoto+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation

protocol CapturePhoto {}
extension AVCapturePhoto: CapturePhoto {}

//
//  CaptureVideoOutput.swift
//  Mocca
//
//  Created by David Fearon on 08/07/2023.
//

import Foundation

protocol CaptureVideoOutput: CaptureOutput {
    func setSampleBufferDelegate(_ delegate: CaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue)
}

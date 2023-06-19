//
//  MockVideoOutput.swift
//  MoccaTests
//
//  Created by David Fearon on 29/06/2023.
//

import Foundation
@testable import Mocca

class MockVideoOutput: CaptureVideoOutput {
    
    var setSampleBufferCallCount = 0
    var sampleBufferDelegateSet: CaptureVideoDataOutputSampleBufferDelegate?
    var queueSet: DispatchQueue?
    func setSampleBufferDelegate(_ delegate: CaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        setSampleBufferCallCount += 1
        sampleBufferDelegateSet = delegate
        queueSet = queue
    }
}

class MockCaptureVideoDataOutputSampleBufferDelegate: CaptureVideoDataOutputSampleBufferDelegate {}

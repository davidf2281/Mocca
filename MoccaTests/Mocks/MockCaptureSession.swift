//
//  MockAVCaptureSession.swift
//  MoccaTests
//
//  Created by David Fearon on 25/07/2019.
//  Copyright © 2019 --. All rights reserved.
//

import Foundation
import AVFoundation
@testable import Mocca

final class MockCaptureSession: CaptureSession {
    
    // MARK: Protocol requirements
    var sessionPreset: AVCaptureSession.Preset = .inputPriority
    var preset: CaptureSessionPreset = .unsupported

    // MARK: Test vars
    var canAddInputResponse =                     true
    var canAddPhotoOutputResponse =               true
    var canAddVideoOutputResponse =               true
    var beginConfigirationCalled =                false
    var addInputCalled =                          false
    var addOuputCalled =                          false
    var commitConfigurationCalled =               false
    var startRunningCalled =                      false
    var stopRunningCalled =                       false
    var beginConfigurationNotCalledWhenRequired = false
    var commitConfigurationCalledPrematurely =    false
    
    private(set) var lastAddedInput: CaptureInput?
    private(set) var lastAddedOutput: CaptureOutput?
    
    // MARK: Protocol implementation
    
    func beginConfiguration() {
        beginConfigirationCalled = true
    }
    
    func canAddInput(_ input: CaptureInput) -> Bool {
        return self.canAddInputResponse
    }
    
    func addInput(_ input: CaptureInput) {
        beginConfigurationNotCalledWhenRequired = !beginConfigirationCalled
        commitConfigurationCalledPrematurely = commitConfigurationCalled
        addInputCalled = true
        lastAddedInput = input
    }
    
    var removedInput: CaptureInput?
    var removeInputCallCount = 0
    func removeInput(_ input: CaptureInput) {
        removeInputCallCount += 1
        removedInput = input
    }
    
    func canAddOutput(_ output: CaptureOutput) -> Bool {
        
        if let _ = output as? CaptureVideoOutput {
            return self.canAddVideoOutputResponse
        } else {
            return self.canAddPhotoOutputResponse
        }        
    }
    
    func addOutput(_ output: CaptureOutput) {
        beginConfigurationNotCalledWhenRequired = !beginConfigirationCalled
        commitConfigurationCalledPrematurely = commitConfigurationCalled
        addOuputCalled = true
        lastAddedOutput = output
    }
    
    func commitConfiguration() {
        beginConfigurationNotCalledWhenRequired = !beginConfigirationCalled
        commitConfigurationCalled = true
    }
    
    func startRunning() {
        startRunningCalled = true
    }
    
    func stopRunning() {
        stopRunningCalled = true
    }
}

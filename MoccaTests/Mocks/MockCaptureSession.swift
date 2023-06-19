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
    internal var canAddInputResponse =                     true
    internal var canAddPhotoOutputResponse =               true
    internal var canAddVideoOutputResponse =               true
    internal var beginConfigirationCalled =                false
    internal var addInputCalled =                          false
    internal var addOuputCalled =                          false
    internal var commitConfigurationCalled =               false
    internal var startRunningCalled =                      false
    internal var stopRunningCalled =                       false
    internal var beginConfigurationNotCalledWhenRequired = false
    internal var commitConfigurationCalledPrematurely =    false
    
    internal private(set) var lastAddedInput: CaptureInput?
    internal private(set) var lastAddedOutput: CaptureOutput?
    
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

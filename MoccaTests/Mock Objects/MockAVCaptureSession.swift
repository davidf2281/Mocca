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

class MockAVCaptureSession: TestableAVCaptureSession {
  
    // MARK: Protocol requirements
    var sessionPreset: AVCaptureSession.Preset = .inputPriority
    
    // MARK: Test vars
    internal var canAddInputResponse =                     true
    internal var canAddOutputResponse =                    true
    internal var beginConfigirationCalled =                false
    internal var addInputCalled =                          false
    internal var addOuputCalled =                          false
    internal var commitConfigurationCalled =               false
    internal var startRunningCalled =                      false
    internal var stopRunningCalled =                       false
    internal var beginConfigurationNotCalledWhenRequired = false
    internal var commitConfigurationCalledPrematurely =    false
    
    internal private(set) var lastAddedInput: AVCaptureDeviceInput?
    internal private(set) var lastAddedOutout: AVCaptureOutput?
    
    // MARK: Protocol implementation
    
    func beginConfiguration() {
        beginConfigirationCalled = true
    }
    
    func canAddInput(_: AVCaptureInput) -> Bool {
        return self.canAddInputResponse
    }
    
    func addInput(_ input: AVCaptureInput) {
        beginConfigurationNotCalledWhenRequired = !beginConfigirationCalled
        commitConfigurationCalledPrematurely = commitConfigurationCalled
        addInputCalled = true
    }
    
    func canAddOutput(_ output: AVCaptureOutput) -> Bool {
        return self.canAddOutputResponse
    }
    
    func addOutput(_ output: AVCaptureOutput) {
        beginConfigurationNotCalledWhenRequired = !beginConfigirationCalled
        commitConfigurationCalledPrematurely = commitConfigurationCalled
        addOuputCalled = true
        lastAddedOutout = output
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

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
    private var canAddInput =                             false
    private var canAddOutput =                            false
    private var beginConfigirationCalled =                false
    private var addInputCalled =                          false
    private var addOuputCalled =                          false
    private var commitConfigurationCalled =               false
    private var startRunningCalled =                      false
    private var stopRunningCalled =                       false
    private var beginConfigurationNotCalledWhenRequired = false
    private var commitConfigurationCalledPrematurely =    false
    
    internal private(set) var lastAddedInput: TestableAVCaptureDeviceInput?
    internal private(set) var lastAddedOutout: AVCaptureOutput?
    
    // MARK: Protocol implementation
    
    func beginConfiguration() {
        beginConfigirationCalled = true
    }
    
    func canAddInput(_: AVCaptureInput) -> Bool {
        return self.canAddInput
    }
    
    func addInput(_ input: AVCaptureInput) {
        beginConfigurationNotCalledWhenRequired = !beginConfigirationCalled
        commitConfigurationCalledPrematurely = !commitConfigurationCalled
        addInputCalled = true
    }
    
    func canAddOutput(_ output: AVCaptureOutput) -> Bool {
        return self.canAddOutput
    }
    
    func addOutput(_ output: AVCaptureOutput) {
        beginConfigurationNotCalledWhenRequired = !beginConfigirationCalled
        commitConfigurationCalledPrematurely = !commitConfigurationCalled
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

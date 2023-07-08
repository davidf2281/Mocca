//
//  ShutterButtonViewModel.swift
//  Mocca
//
//  Created by David Fearon on 04/10/2020.
//

import Foundation
import Combine

protocol ShutterButtonViewModelContract: ObservableObject {
    var state: CaptureManagerState { get }
    func tapped()
}

class ShutterButtonViewModel: ShutterButtonViewModelContract {
    
    @Published private(set) var state: CaptureManagerState
    
    private(set) var captureManager: CaptureManagerContract?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(captureManager: CaptureManagerContract?) {
        self.captureManager = captureManager
        self.state = captureManager?.state ?? .error(.unknown)
        
        captureManager?.statePublisher
            .sink() { [weak self] value in
                DispatchQueue.main.async {
                    self?.state = value
                }
            }.store(in: &cancellables)
    }
    
    func tapped () {
        self.captureManager?.capturePhoto()
    }
}

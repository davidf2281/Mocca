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
    
    private(set) var photoTaker: CaptureManagerContract?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(photoTaker: CaptureManagerContract?) {
        self.photoTaker = photoTaker
        self.state = photoTaker?.state ?? .error(.unknown)
        
        photoTaker?.statePublisher
            .sink() { [weak self] value in
                DispatchQueue.main.async {
                    self?.state = value
                }
            }.store(in: &cancellables)
    }
    
    func tapped () {
        self.photoTaker?.capturePhoto()
    }
}

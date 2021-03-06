//
//  ShutterButtonViewModel.swift
//  Mocca
//
//  Created by David Fearon on 04/10/2020.
//

import Foundation
import Combine

protocol ShutterButtonViewModelProtocol: ObservableObject {
    var state: PhotoTakerState { get }
    func tapped()
}

class ShutterButtonViewModel: ShutterButtonViewModelProtocol {
    
    @Published private(set) var state: PhotoTakerState
    
    private(set) var photoTaker: PhotoTaker
    
    private var cancellables = Set<AnyCancellable>()
    
    init(photoTaker: ConcretePhotoTaker) {
        self.photoTaker = photoTaker
        self.state = photoTaker.state
        
        // Bind model's state with ours:
        photoTaker.$state
            .sink() { value in
                DispatchQueue.main.async {
                    self.state = value
                }
            }.store(in: &cancellables)
    }
    
    public func tapped () {
        // MARK: TODO: Do something with the outcome
        _ = self.photoTaker.takePhoto()
    }
    
    deinit {
        cancellables.removeAll()
    }
}

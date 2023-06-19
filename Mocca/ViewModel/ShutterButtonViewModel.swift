//
//  ShutterButtonViewModel.swift
//  Mocca
//
//  Created by David Fearon on 04/10/2020.
//

import Foundation
import Combine

protocol ShutterButtonViewModelContract: ObservableObject {
    var state: PhotoTakerState { get }
    func tapped()
}

class ShutterButtonViewModel: ShutterButtonViewModelContract {
    
    @Published private(set) var state: PhotoTakerState
    
    private(set) var photoTaker: PhotoTakerContract?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(photoTaker: PhotoTakerContract?) {
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
        self.photoTaker?.takePhoto()
    }
}

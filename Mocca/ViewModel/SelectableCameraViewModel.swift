//
//  SelectableCameraViewModel.swift
//  Mocca
//
//  Created by David Fearon on 07/07/2023.
//

import Foundation

struct SelectableCameraViewModel: Identifiable {
    
    let id: UUID
    
    private let model: PhysicalCamera
    
    init(model: PhysicalCamera) {
        self.model = model
        self.id = model.id
    }
    
    var displayName: String {
        switch self.model.type {
            case .builtInWideAngleCamera:
                return "Wide"
            case .builtInUltraWideCamera:
                return "Ultrawide"
            case .builtInTelephotoCamera:
                return "Telephoto"
            default:
                assert(false)
                return ""
        }
    }
}

extension SelectableCameraViewModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        rhs.model == lhs.model
    }
}

extension SelectableCameraViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.model.position)
        hasher.combine(self.model.type)
    }
}

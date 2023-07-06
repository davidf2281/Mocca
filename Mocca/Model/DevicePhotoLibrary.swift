//
//  DevicePhotoLibrary.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import Foundation
import Photos
import AVFoundation

protocol PhotoLibrary {
    func addPhoto(_ photo: CapturePhoto, completion: @escaping (Bool, Error?) -> ())
}

class DevicePhotoLibrary: PhotoLibrary {
    
    private let library = PHPhotoLibrary.shared()
    
    func addPhoto(_ photo: CapturePhoto, completion: @escaping (Bool, Error?) -> ()) {
        
        guard
            let avPhoto = photo as? AVCapturePhoto,
            let avPhotoData = avPhoto.fileDataRepresentation() else {
            assert(false)
            completion(false, nil)
            return
        }
        
        let changeBlock = {
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: avPhotoData, options: nil)
        }
        
        self.library.performChanges(changeBlock) { success, error in
            completion(success, error)
        }
    }
}

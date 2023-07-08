//
//  PhotoTaker.swift
//  Mocca
//
//  Created by David Fearon on 04/10/2020.
//

import Foundation
import AVFoundation

protocol PhotoCaptureIntermediaryDelegate: AnyObject {
    func didFinishProcessingPhoto(_ photo: CapturePhoto, error: Error?)
}

class PhotoCaptureIntermediary: NSObject, AVCapturePhotoCaptureDelegate, CapturePhotoDelegate {

    weak var delegate: PhotoCaptureIntermediaryDelegate?

    // TODO: Delete this initializer
    init(delegate: PhotoCaptureIntermediaryDelegate) {
        self.delegate = delegate
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        delegate?.didFinishProcessingPhoto(photo, error: error)
    }
}

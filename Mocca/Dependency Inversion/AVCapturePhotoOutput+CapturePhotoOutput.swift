//
//  AVCapturePhotoOutput+DependencyInversion.swift
//  Mocca
//
//  Created by David Fearon on 29/06/2023.
//

import AVFoundation

extension AVCapturePhotoOutput: CapturePhotoOutput {

    var livePhotoCaptureEnabled: Bool {
        get {
            self.isLivePhotoCaptureEnabled
        }
        
        set {
            self.isLivePhotoCaptureEnabled = newValue
        }
    }
    
    func connection() -> CaptureConnection? {
        return self.connection(with: .video)
    }
    
    func capture(with settings: CapturePhotoSettings, delegate: CapturePhotoDelegate) {
        guard let settings = settings as? AVCapturePhotoSettings,
              let delegate = delegate as? AVCapturePhotoCaptureDelegate else {
            // TODO: Return a Result here instead
            assert(false)
            return
        }
        
        self.capturePhoto(with: settings, delegate: delegate)
    }
    
    var maxQualityPrioritization: PhotoQualityPrioritization {
        get {
            switch self.maxPhotoQualityPrioritization {
                case .quality:
                    return .quality
                default:
                    return .unsupported
            }
        }
        set {
            switch newValue {
                case .quality:
                    self.maxPhotoQualityPrioritization = .quality
                case .unsupported:
                    fatalError()
            }
        }
    }
    
    var availablePhotoCodecs: [PhotoCodec] {
        self.availablePhotoCodecTypes.compactMap {
            if case .hevc = $0 {
                return .hevc
            }
            
            return nil
        }
    }
}

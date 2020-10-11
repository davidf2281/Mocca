//
//  MoccaApp.swift
//  Mocca
//
//  Created by David Fearon on 24/09/2020.
//

import SwiftUI
import AVFoundation
import Photos
import Combine
@main

final class MoccaApp: App, ObservableObject {

    @Published var appState: AppState = .nominal
 
    private var photoTaker: DevicePhotoTaker?
    
    /// Capture manager is the intermediary class dealing with all communication with the device's physical camera hardware.
    private let captureManager : DeviceCaptureManager? = {
        var manager : DeviceCaptureManager?
        do { try manager = DeviceCaptureManager() } catch { manager = nil }
        return manager
    }()
    
    /// Camera apps cannot conform to the Apple ideal of disregarding orientation and considering only frame bounds & size classes,
    /// thus current device orientation needs to be consumed by various views and the capture manager.
    /// This OrientationPublisher acts as the app's source of truth for orientation.
    private let orientationPublisher = OrientationPublisher()
    
    /// Queue used to take blocking calls to the camera hardware off the main thread.
    private let sessionQueue = DispatchQueue(label: "com.mocca-app.sessionQueue")
    
    /// Capture-session video preview (ie, camera viewfinder).
    private let previewUIView = PreviewUIView()
    
    /// Main view hierarchy for the app.
    private var ContentViews: some View {
        
        // MARK: TODO: Configuring non-UI app state in this function feels like a misuse. Consider a different approach.
        
        // Photo taker responds to messages from shutter viewmodel to kick off the photo-capture process.
        self.photoTaker = DevicePhotoTaker(captureManager: captureManager ?? nil, photoLibrary: PHPhotoLibrary.shared())
        
        // We must always have a PhotoTaker
        guard let taker = self.photoTaker else {
            fatalError("Programmer error: photoTaker must not be nil")
        }
        
        // If capture-manager setup has failed we have a hardware problem, OR we're running in the simulator.
        self.appState = captureManager != nil ?
            .nominal : System.runningInSimulator() ?
            .nominal : .cameraFailure
        
        // Capture manager requires a reference to the video preview layer to convert view coords to device coords using the AVCaptureVideoPreviewLayer's point-conversion functions. Only the preview layer can do this.
        captureManager?.videoPreviewLayer = previewUIView.videoPreviewLayer
        
        sessionQueue.async {
            self.captureManager?.startCaptureSession()
            DispatchQueue.main.async {
                self.previewUIView.videoPreviewLayer.session = self.captureManager?.captureSession as? AVCaptureSession
                self.previewUIView.videoPreviewLayer.connection?.videoOrientation = Orientation.AVOrientation(for: Orientation.currentInterfaceOrientation())
                self.previewUIView.videoPreviewLayer.videoGravity = .resizeAspect
            }
        }
        
        /// Backs widget view to show current focus/exposure point
        let widgetViewModel = WidgetViewModel(captureManager: captureManager, dockedPosition:CGPoint(x: 55, y: 55), displayCharacter:"f")
        
        /// Backs camera preview view, sending taps to capture manager dependency to set focus/exposure point
        let previewViewModel = PreviewViewModel(captureManager: captureManager)
        
        /// Backs the shutter button, sending taps to photoTaker dependency
        let shutterButtonViewModel = ShutterButtonViewModel(photoTaker: taker)
        
        /// Representable UIViewController container for camera preview, since SwiftUI does not yet support this natively
        let previewViewController = PreviewViewController(previewView: previewUIView, orientationPublisher: orientationPublisher)
        
        // Compose our main app view.
        return ContentView(
            app: self,
            previewViewController:previewViewController,
            widgetViewModel: widgetViewModel,
            shutterButtonViewModel: shutterButtonViewModel,
            previewViewModel: previewViewModel,
            cameraErrorView: CameraErrorView())
            .environmentObject(orientationPublisher)
            .background(Color.black)
            .statusBar(hidden: true)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentViews
        }
    }
}

enum AppState {
    case nominal
    case cameraFailure
}

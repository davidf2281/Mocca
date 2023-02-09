//
//  MoccaApp.swift
//  Mocca
//
//  Created by David Fearon on 24/09/2020.
//

import SwiftUI
import Photos
@main

final class MoccaApp: App, ObservableObject {

    @Published var appState: AppState = .nominal
 
    /// Photo taker responds to messages from shutter viewmodel to kick off the photo-capture process.
    private var photoTaker: DevicePhotoTaker
    
    /// Backs widget view to show current focus/exposure point.
    private let widgetViewModel: WidgetViewModel
    
    /// Backs camera preview view, sending taps to capture manager dependency to set focus/exposure point.
    private let previewViewModel: PreviewViewModel
    
    /// Representable UIViewController container for camera preview, since SwiftUI does not yet support this natively.
    private let previewViewController: PreviewViewControllerRepresentable
    
    /// Backs the shutter button, sending taps to photoTaker dependency
    private let shutterButtonViewModel: ShutterButtonViewModel
    
    /// Backs the histogram view and controls histogram generator
    private let histogramViewModel: HistogramViewModel
    
    /// Backs exposure bias indicator and receives exposure-bias UI events from preview view controller
    private let exposureBiasViewModel: ExposureBiasViewModel
    
    /// Capture manager is the intermediary class dealing with all communication with the device's physical camera hardware.
    private let captureManager: DeviceCaptureManager? = {
        var manager : DeviceCaptureManager?
        do { try manager = DeviceCaptureManager(resources: DeviceResources.shared) } catch { manager = nil }
        return manager
    }()
    
    private let histogramGenerator = HistogramGenerator(mtlDevice: DeviceResources.shared.metalDevice)
    
    /// Camera apps cannot conform to the Apple ideal of disregarding orientation and considering only frame bounds & size classes,
    /// thus current device orientation needs to be consumed by various views and the capture manager.
    /// This OrientationPublisher acts as the app's source of truth for orientation.
    private let orientationPublisher = OrientationPublisher()
    
    /// Queue used to take blocking calls to the camera hardware off the main thread.
    private let sessionQueue = DispatchQueue(label: "com.mocca-app.sessionQueue")
    
    /// Capture-session video preview (ie, camera viewfinder).
    private let previewUIView = PreviewUIView()
    
    private let sampleBufferIntermediary: SampleBufferIntermediary
    
    init() {
        
        // If capture-manager setup has failed we have a hardware problem, OR we're running in the simulator.
        self.appState = captureManager != nil ?
            .nominal : System.runningInSimulator() ?
            .nominal : .cameraFailure
        
        // Capture manager requires a reference to the video preview layer to convert view coords to camera-device coords using
        // AVCaptureVideoPreviewLayer's point-conversion functions. Only the preview layer can do this.
        captureManager?.videoPreviewLayer = previewUIView.videoPreviewLayer
        
        self.photoTaker =             DevicePhotoTaker(captureManager: self.captureManager ?? nil, photoLibrary: PHPhotoLibrary.shared())
        let sampleBufferQueue = DispatchQueue(label: "com.mocca-app.videoSampleBufferQueue")
        self.histogramViewModel =     HistogramViewModel(histogramGenerator: self.histogramGenerator)
        self.sampleBufferIntermediary = SampleBufferIntermediary(sampleBufferHandler: self.histogramViewModel)
        self.captureManager?.setSampleBufferDelegate(self.sampleBufferIntermediary, queue: sampleBufferQueue)
        self.widgetViewModel =        WidgetViewModel(captureManager: captureManager, dockedPosition:CGPoint(x: 55, y: 55), displayCharacter:"f")
        self.previewViewModel =       PreviewViewModel(captureManager: captureManager)
        self.previewViewController =  PreviewViewControllerRepresentable(previewView: previewUIView, orientationPublisher: orientationPublisher)
        self.shutterButtonViewModel = ShutterButtonViewModel(photoTaker: photoTaker)
        self.exposureBiasViewModel =  ExposureBiasViewModel(captureManager: captureManager)
        
        sessionQueue.async { [weak self] in
            self?.captureManager?.startCaptureSession()
            DispatchQueue.main.async {
                self?.previewUIView.videoPreviewLayer.session = self?.captureManager?.captureSession as? AVCaptureSession
                self?.previewUIView.videoPreviewLayer.connection?.videoOrientation = Orientation.AVOrientation(for: Orientation.currentInterfaceOrientation())
                self?.previewUIView.videoPreviewLayer.videoGravity = .resizeAspect
            }
        }
    }
    
    /// Main view hierarchy for the app.
    private var ContentViews: some View {
        // Compose our main app view.
        return ContentView(
            app: self,
            previewViewController:  previewViewController,
            widgetViewModel:        widgetViewModel,
            shutterButtonViewModel: shutterButtonViewModel,
            previewViewModel:       previewViewModel,
            exposureBiasViewModel:  exposureBiasViewModel,
            histogramViewModel:     histogramViewModel,
            cameraErrorView:        CameraErrorView())
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

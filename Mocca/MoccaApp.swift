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
        
    /// Provides access to device hardware
    private let deviceResources: DeviceResourcesContract?
    
    /// Capture manager is the intermediary class dealing with all communication with the device's physical camera hardware.
    private let captureManager: (CaptureManagerContract & PhotoTakerContract)?
    
    private let histogramGenerator: HistogramGeneratorContract?
    
    /// Camera apps cannot conform to the Apple ideal of disregarding orientation and considering only frame bounds & size classes,
    /// thus current device orientation needs to be consumed by various views and the capture manager.
    /// This OrientationPublisher acts as the app's source of truth for orientation.
    private let orientationPublisher = OrientationPublisher()
    
    /// Queue used to take blocking calls to the camera hardware off the main thread.
    private let sessionQueue = DispatchQueue(label: "com.mocca-app.sessionQueue")
    
    /// Capture-session video preview (ie, camera viewfinder).
    private let previewUIView = PreviewUIView(viewModel: PreviewUIViewModel())
    
    private let sampleBufferIntermediary: SampleBufferIntermediary
    
    private let configurationFactory: ConfigurationFactoryContract = ConfigurationFactory(captureDeviceInputType: AVCaptureDeviceInput.self)
    
    private let cameraSelectionModel: CameraSelection
    
    enum MoccaSetupError: Error {
        case deviceResources
    }
    
    init() {
                
        self.deviceResources = DeviceResources(captureDevice: AVCaptureDevice.default(for: .video), supportedCameraDevices: self.configurationFactory.supportedCameraDevices)
        
        do {
            guard let deviceResources = self.deviceResources else {
                throw(MoccaSetupError.deviceResources)
            }
            
            let config = try self.configurationFactory.captureManagerInitializerConfiguration(
                resources: deviceResources,
                videoPreviewLayer: previewUIView.videoPreviewLayer,
                captureSession: AVCaptureSession(),
                captureDeviceInputType: AVCaptureDeviceInput.self,
                photoOutputType: AVCapturePhotoOutput.self)
            
            self.captureManager = try CaptureManager(captureSession: config.captureSession,
                                                     photoOutput: config.photoOutput,
                                                     videoOutput: config.videoOutput,
                                                     initialCaptureDevice: config.initialCaptureDevice,
                                                     videoInput: config.videoInput,
                                                     resources: config.resources,
                                                     videoPreviewLayer: config.videoPreviewLayer,
                                                     photoLibrary: config.photoLibrary,
                                                     configurationFactory: self.configurationFactory)
        } catch {
            self.captureManager = nil
        }

        // If capture-manager setup has failed we have a hardware problem, OR we're running in the simulator.
        self.appState = captureManager != nil ?
            .nominal : System.runningInSimulator() ?
            .nominal : .cameraFailure
        
        if let histogramGenerator = HistogramGenerator(metalDevice: self.deviceResources?.metalDevice) {
            self.histogramGenerator = histogramGenerator
        } else {
            self.histogramGenerator = nil
        }
        
        let sampleBufferQueue = DispatchQueue(label: "com.mocca-app.videoSampleBufferQueue")
        self.histogramViewModel = HistogramViewModel(histogramGenerator: self.histogramGenerator)
        self.sampleBufferIntermediary = SampleBufferIntermediary(sampleBufferHandler: self.histogramViewModel)
        self.captureManager?.setSampleBufferDelegate(self.sampleBufferIntermediary, queue: sampleBufferQueue)
        self.widgetViewModel = WidgetViewModel(captureManager: captureManager, dockedPosition:CGPoint(x: 55, y: 55), displayCharacter:"f")
        self.previewViewModel = PreviewViewModel(captureManager: captureManager)
        self.previewViewController = PreviewViewControllerRepresentable(viewModel: PreviewViewControllerViewModel(previewView: self.previewUIView, orientationPublisher: self.orientationPublisher, orientation: Orientation()))
        self.shutterButtonViewModel = ShutterButtonViewModel(photoTaker: self.captureManager)
        self.exposureBiasViewModel = ExposureBiasViewModel(captureManager: captureManager)
        self.cameraSelectionModel = CameraSelectionModel(availableCameras: self.configurationFactory.supportedCameraDevices, captureManager: self.captureManager!) // TODO: Address force-unwrapped optional
        sessionQueue.async { [weak self] in
            self?.captureManager?.startCaptureSession()
            DispatchQueue.main.async {
                self?.previewUIView.videoPreviewLayer?.captureSession = self?.captureManager?.captureSession as? CaptureSession
                self?.previewUIView.videoPreviewLayer?.captureConnection?.orientation = Orientation.currentInterfaceOrientation()
                self?.previewUIView.videoPreviewLayer?.gravity = .resizeAspect
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
            cameraErrorView:        CameraErrorView(viewModel: CameraErrorViewModel()))
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

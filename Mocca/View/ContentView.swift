//
//  ContentView.swift
//  Mocca
//
//  Created by David Fearon on 24/09/2020.
//

import SwiftUI

struct ContentView: View {
    
    /// App state is required to decide whether to show camera error view
    @ObservedObject var app: MoccaApp
    
    /// View model for the preview
    @ObservedObject var previewViewModel: PreviewViewModel
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    private let previewController: PreviewViewController
    private let widgetViewModel:    WidgetViewModel
    private let shutterButtonViewModel: ShutterButtonViewModel
    private let histogramViewModel: HistogramViewModel
    private let cameraErrorView:   CameraErrorView
    
    init(app: MoccaApp, previewViewController: PreviewViewController, widgetViewModel:WidgetViewModel, shutterButtonViewModel: ShutterButtonViewModel, previewViewModel:PreviewViewModel, histogramViewModel: HistogramViewModel, cameraErrorView:CameraErrorView) {
        self.app = app
        self.previewController = previewViewController
        self.widgetViewModel = widgetViewModel
        self.shutterButtonViewModel = shutterButtonViewModel
        self.previewViewModel = previewViewModel
        self.histogramViewModel = histogramViewModel
        self.cameraErrorView = cameraErrorView
    }
    
    var body: some View {
        
        let previewView = PreviewView(widgetViewModel: widgetViewModel, previewViewModel: self.previewViewModel, previewViewController: self.previewController)
        
        let shutterButtonView = ShutterButtonView<ShutterButtonViewModel>(viewModel: shutterButtonViewModel)
            .padding(20)
        
        let histogramView = HistogramView(viewModel: histogramViewModel)
        
        if self.app.appState == .nominal {
            if verticalSizeClass == .regular {
                VStack(alignment:.center) {
           
                    Spacer()
                    previewView
                    Spacer()
                    // MARK: TODO: Select-camera control
                    ZStack {

                        shutterButtonView
                        histogramView.offset(x: 105, y: 0)
                    }
                    Spacer()
                }.background(Color.black)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                HStack {
                    Spacer()
                    VStack {
                        previewView
                            Spacer()
                            histogramView
                            Spacer()
                    }
                    Spacer()
                    shutterButtonView
                    Spacer()
                }.background(Color.black)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            cameraErrorView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 1, green: 1, blue: 0.95))
        }
    }
}

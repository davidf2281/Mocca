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
    
    let previewController: PreviewViewController
    let widgetViewModel:    WidgetViewModel
    let shutterButtonViewModel: ShutterButtonViewModel
    let cameraErrorView:   CameraErrorView
    
    init(app: MoccaApp, previewViewController: PreviewViewController, widgetViewModel:WidgetViewModel, shutterButtonViewModel: ShutterButtonViewModel, previewViewModel:PreviewViewModel, cameraErrorView:CameraErrorView) {
        self.app = app
        self.previewController = previewViewController
        self.widgetViewModel = widgetViewModel
        self.shutterButtonViewModel = shutterButtonViewModel
        self.previewViewModel = previewViewModel
        self.cameraErrorView = cameraErrorView
    }
    
    var body: some View {
        
        let previewView = PreviewView(widgetViewModel: widgetViewModel, previewViewModel: self.previewViewModel, previewViewController: self.previewController)
        
        let shutterButtonView = ShutterButtonView(viewModel: shutterButtonViewModel)
            .padding(20)
        
        if self.app.appState == .nominal {
                if verticalSizeClass == .regular {
                    VStack {
                        Spacer()
                        previewView
                        Spacer()
                        // MARK: TODO: Select-camera control
                        shutterButtonView
                        Spacer()
                    }.background(Color.black)
                } else {
                    HStack {
                        Spacer()
                        previewView
                        Spacer()
                        shutterButtonView
                        Spacer()
                    }.background(Color.black)
                }
        } else {
            cameraErrorView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 1, green: 1, blue: 0.95))
        }
    }
}

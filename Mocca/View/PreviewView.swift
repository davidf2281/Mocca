//
//  PreviewView.swift
//  Mocca
//
//  Created by David Fearon on 03/10/2020.
//

import SwiftUI

protocol PreviewViewContract: View {}

struct PreviewView: PreviewViewContract {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var orientationPublisher: OrientationPublisher
    
    let widgetViewModel: WidgetViewModel
    let previewViewModel: PreviewViewModel
    let exposureBiasViewModel: ExposureBiasViewModel
    let previewViewController: PreviewViewControllerRepresentable
    
    var body: some View {
        
        let aspectRatio = verticalSizeClass == .regular ?
        self.previewViewModel.aspectRatio :
        1 / self.previewViewModel.aspectRatio
        
        let sizeClass: UserInterfaceSizeClass = verticalSizeClass == .regular ? .regular : .compact
        
        let previewModifier = PreviewModifier(aspectRatio: aspectRatio, verticalSizeClass: sizeClass, widgetViewModel: widgetViewModel, previewViewModel: previewViewModel, exposureBiasViewModel: exposureBiasViewModel)
        
        if System.runningInSimulator() == false {
            self.previewViewController
                .modifier(previewModifier)
        } else {
            SimulatorPreview()
                .modifier(previewModifier)
        }
    }
}

struct PreviewModifier: ViewModifier {
    
    @EnvironmentObject var orientationPublisher: OrientationPublisher
    
    let aspectRatio: CGFloat
    let verticalSizeClass: UserInterfaceSizeClass
    let widgetViewModel: WidgetViewModel
    let previewViewModel: PreviewViewModel
    let exposureBiasViewModel: ExposureBiasViewModel
    
    func body(content: Content) -> some View {
        
        let margin = CGFloat(5)
        
        let edgeInsets = verticalSizeClass == .regular ?
        EdgeInsets(top: 0, leading: margin, bottom: 0, trailing: margin) :
        EdgeInsets(top: margin, leading: 0, bottom: margin, trailing: 0)
        
        GeometryReader { parent in
            content
                .border(Color(white: 1), width: 5)
                .overlay(WidgetView( viewModel: widgetViewModel).accessibility(label: Text("reticle")))
                .gesture(SpatialTapGesture()
                    .onEnded { value in
                        let frameSize = CGSize(width: parent.size.width - (edgeInsets.leading + edgeInsets.trailing), height: parent.size.height - (edgeInsets.top + edgeInsets.bottom))
                        let position = ViewConversion.tapPosition(position: value.location,
                                                                  orientation: orientationPublisher.interfaceOrientation, parentFrame: frameSize)
                        self.widgetViewModel.position = position
                        self.previewViewModel.tapped(position: value.location, frameSize:frameSize)
                    }
                )
                .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onChanged { gesture in
                        self.exposureBiasViewModel.dragged(extent: -gesture.translation.height)
                    }
                    .onEnded {_ in
                        self.exposureBiasViewModel.dragEnded()
                    }
                )
        }.aspectRatio(aspectRatio, contentMode: .fit)
            .padding(edgeInsets)
            .background(Color.black)
    }
}


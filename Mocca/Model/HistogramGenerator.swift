//
//  HistogramGenerator.swift
//  Mocca
//
//  Created by David Fearon on 21/10/2020.
//

import Foundation
import MetalPerformanceShaders
import AVFoundation

public class HistogramGenerator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let sampleBufferQueue = DispatchQueue(label: "com.mocca-app.videoSampleBufferQueue")
    
    private let mtlDevice: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let commandBuffer: MTLCommandBuffer
    
    required public init(mtlDevice: MTLDevice) {
        self.mtlDevice = mtlDevice
        let commandQueue = mtlDevice.makeCommandQueue()! // MARK: TODO: Something safer here than force-unwrapping
        self.commandQueue = commandQueue
        self.commandBuffer = commandQueue.makeCommandBuffer()! // MARK: TODO: Something safer here than force-unwrapping
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        var mtlTextureCache : CVMetalTextureCache?
        CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, mtlDevice, nil, &mtlTextureCache)
        
        var textureRef : CVMetalTexture?
        CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, mtlTextureCache! /* MARK:<- force-unwrapping */, imageBuffer, nil, MTLPixelFormat.bgra8Unorm, width, height, 0, &textureRef)
        let imageTexture = CVMetalTextureGetTexture(textureRef!)! // MARK: TODO: Something safer here than force-unwrapping
        
        var histogramInfo = MPSImageHistogramInfo(
            numberOfHistogramEntries: 256,
            histogramForAlpha: false,
            minPixelValue: vector_float4(0,0,0,0),
            maxPixelValue: vector_float4(1,1,1,1))
        
        let histogram = MPSImageHistogram(device: mtlDevice,
                                          histogramInfo: &histogramInfo)
        
        let bufferLength = histogram.histogramSize(forSourceFormat: imageTexture.pixelFormat)
        
        let histogramResults = mtlDevice.makeBuffer(length: bufferLength,
                                                       options: [.storageModePrivate])! // MARK: TODO: Something safer here than force-unwrapping
        
        histogram.encode(to: self.commandBuffer,
                         sourceTexture: imageTexture,
                         histogram: histogramResults,
                         histogramOffset: 0)
        
        self.commandBuffer.commit()
        self.commandBuffer.waitUntilCompleted()
        print("Finished generating histogram")
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Dropped frame")
    }
}

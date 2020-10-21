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
    let processingBufferQueue = DispatchQueue(label: "com.mocca-app.histogramProcessingQueue")
    private let mtlDevice: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let commandBuffer: MTLCommandBuffer
    
    required public init(mtlDevice: MTLDevice) {
        self.mtlDevice = mtlDevice
        let commandQueue = mtlDevice.makeCommandQueue()! // MARK: TODO: Something safer here than force-unwrapping
        self.commandQueue = commandQueue
        let buffer = commandQueue.makeCommandBuffer()! // MARK: TODO: Something safer here than force-unwrapping
        self.commandBuffer = buffer
        if buffer.retainedReferences == false {
            print("Buffer is not retaining references")
        }
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        self.processingBufferQueue.async { [self] in
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            let width = CVPixelBufferGetWidth(imageBuffer)
            let height = CVPixelBufferGetHeight(imageBuffer)
            
            var mtlTextureCache : CVMetalTextureCache?
            CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, mtlDevice, nil, &mtlTextureCache)
            
            if (mtlTextureCache == nil) {
                print("nil mtlTextureCache")
                return
            }
            
            var textureRef : CVMetalTexture?
            CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, mtlTextureCache!, imageBuffer, nil, MTLPixelFormat.bgra8Unorm, width, height, 0, &textureRef)
            
            if (textureRef == nil) {
                print("nil textureRef")
                return
            }
            
            guard let imageTexture = CVMetalTextureGetTexture(textureRef!) else {
                print("nil imageTexture")
                return
            }
            
            var histogramInfo = MPSImageHistogramInfo(
                numberOfHistogramEntries: 128,
                histogramForAlpha: false,
                minPixelValue: vector_float4(0,0,0,0),
                maxPixelValue: vector_float4(1,1,1,1))
            
            let histogram = MPSImageHistogram(device: mtlDevice,
                                              histogramInfo: &histogramInfo)
            
            let bufferLength = histogram.histogramSize(forSourceFormat: imageTexture.pixelFormat)
            
            guard let histogramResults = mtlDevice.makeBuffer(length: bufferLength,
                                                              options: [.storageModeShared]) else {
                print("nil histogramResults")
                return
            }
            guard let buffer = self.commandQueue.makeCommandBuffer() else {
                print("makeCommandBuffer() failed")
                return
            }
            histogram.encode(to: buffer,
                             sourceTexture: imageTexture,
                             histogram: histogramResults,
                             histogramOffset: 0)
            
            buffer.commit()
            buffer.waitUntilCompleted()
            let dataPtr = histogramResults.contents().assumingMemoryBound(to: Int32.self)
//            for i in 0..<128 {
                //                     if dataPtr[i] != 0 {
            let value = dataPtr[20]
                print("\(value & 0xFF) \((value >> 8) & 0xFF) \((value >> 16) & 0xFF) \((value >> 24) & 0xFF)")
                //                     }
//            }
            print("FINISHED")
        }
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Dropped frame")
    }
}

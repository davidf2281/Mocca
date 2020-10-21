//
//  HistogramGenerator.swift
//  Mocca
//
//  Created by David Fearon on 21/10/2020.
//

import Foundation
import MetalPerformanceShaders
import AVFoundation

public struct HistogramBin {
    let value: UInt8
    let indexForID: Int
    init(value: UInt8, index: Int) {
        self.value = value
        self.indexForID = index
    }
}

public struct Histogram {
    let redBins: [HistogramBin]
    let greenBins: [HistogramBin]
    let blueBins: [HistogramBin]
}

public class HistogramGenerator: NSObject, HistogramViewModel, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @Published private(set) var histogram: Histogram?
    
    let sampleBufferQueue = DispatchQueue(label: "com.mocca-app.videoSampleBufferQueue")
    private let processingBufferQueue = DispatchQueue(label: "com.mocca-app.histogramProcessingQueue")
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
        
        let binCount = 128
        
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
                numberOfHistogramEntries: binCount,
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
            
            var redBins = [HistogramBin]()
            var greenBins = [HistogramBin]()
            var blueBins = [HistogramBin]()

            for index in 0..<binCount {
                let value = dataPtr[index]
                let red = UInt8(value & 0xFF)
                let green = UInt8((value >> 8) & 0xFF)
                let blue = UInt8((value >> 16) & 0xFF)
                
                redBins.append(HistogramBin(value: red, index: index))
                greenBins.append(HistogramBin(value: green, index: index))
                blueBins.append(HistogramBin(value: blue, index: index))
//                print("\(value & 0xFF) \((value >> 8) & 0xFF) \((value >> 16) & 0xFF) \((value >> 24) & 0xFF)")
            }
            DispatchQueue.main.async {
                self.histogram = Histogram(redBins: redBins, greenBins: greenBins, blueBins: blueBins)
            }
        }
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Dropped frame")
    }
}

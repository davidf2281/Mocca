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
    let value: UInt32
    let index: Int
    let ID: Int
    init(value: UInt32, index: Int, ID: Int) {
        self.value = value
        self.index = index
        self.ID = ID
    }
}

public struct Histogram {
    let maxValue: UInt32
    let redBins: [HistogramBin]
    let greenBins: [HistogramBin]
    let blueBins: [HistogramBin]
}

public class HistogramGenerator {
    
    private let mtlDevice: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let commandBuffer: MTLCommandBuffer
    private var allTimeMaxValue: UInt32 = 0
    
    required public init?(mtlDevice: MTLDevice) {
        self.mtlDevice = mtlDevice
        
        guard let commandQueue = mtlDevice.makeCommandQueue() else {
            return nil
        }
        self.commandQueue = commandQueue
        
        guard let buffer = commandQueue.makeCommandBuffer() else {
            return nil
        }
        self.commandBuffer = buffer
        
        if buffer.retainedReferences == false {
            print("Warning: Buffer is not retaining references")
        }
    }
    
    public func generate(sampleBuffer: CMSampleBuffer) -> Histogram? {
        
        let binCount = 64
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        var mtlTextureCache : CVMetalTextureCache?
        CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, mtlDevice, nil, &mtlTextureCache)
        
        if (mtlTextureCache == nil) {
            return nil
        }
        
        var textureRef : CVMetalTexture?
        CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, mtlTextureCache!, imageBuffer, nil, MTLPixelFormat.bgra8Unorm_srgb, width, height, 0, &textureRef)
        
        if (textureRef == nil) {
            return nil
        }
        
        guard let imageTexture = CVMetalTextureGetTexture(textureRef!) else {
            return nil
        }
        
        var histogramInfo = MPSImageHistogramInfo(numberOfHistogramEntries: binCount,
                                                  histogramForAlpha: false,
                                                  minPixelValue: vector_float4(0,0,0,0),
                                                  maxPixelValue: vector_float4(1,1,1,1))
        
        let histogram = MPSImageHistogram(device: mtlDevice,
                                          histogramInfo: &histogramInfo)
        
        let bufferLength = histogram.histogramSize(forSourceFormat: imageTexture.pixelFormat)
        
        guard let histogramResults = mtlDevice.makeBuffer(length: bufferLength,
                                                          options: [.storageModeShared]) else {
            print("nil histogramResults")
            return nil
        }
        
        guard let buffer = self.commandQueue.makeCommandBuffer() else {
            print("makeCommandBuffer() failed")
            return nil
        }
        
        histogram.encode(to: buffer,
                         sourceTexture: imageTexture,
                         histogram: histogramResults,
                         histogramOffset: 0)
        
        buffer.commit()
        buffer.waitUntilCompleted()
        
        let dataPointer = histogramResults.contents().assumingMemoryBound(to: UInt32.self)
        
        var redBins =   [HistogramBin]()
        var greenBins = [HistogramBin]()
        var blueBins =  [HistogramBin]()
                
        for index in stride(from: 0, to: binCount, by: 1) {
            let blue = dataPointer[index]
            blueBins.append(HistogramBin(value: blue, index: index, ID: index))
        }
        
        for index in stride(from: binCount, to: binCount * 2, by: 1) {
            let green = dataPointer[index]
            greenBins.append(HistogramBin(value: green, index: index - binCount, ID: index))
        }
        
        for index in stride(from: binCount * 2, to: binCount * 3, by: 1) {
            let red = dataPointer[index]
            redBins.append(HistogramBin(value:red, index: index - binCount * 2, ID: index))
        }
        
        return Histogram(maxValue: UInt32(width * height), redBins: redBins, greenBins: greenBins, blueBins: blueBins)
    }
}

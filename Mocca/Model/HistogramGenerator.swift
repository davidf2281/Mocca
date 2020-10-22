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
        
        let binCount = 128
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        var mtlTextureCache : CVMetalTextureCache?
        CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, mtlDevice, nil, &mtlTextureCache)
        
        if (mtlTextureCache == nil) {
            return nil
        }
        
        var textureRef : CVMetalTexture?
        CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, mtlTextureCache!, imageBuffer, nil, MTLPixelFormat.rg8Unorm, width / 2, height / 2, 1, &textureRef)
        
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
            return nil
        }
        
        guard let buffer = self.commandQueue.makeCommandBuffer() else {
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
//        var redTotal:UInt32 = 0, greenTotal:UInt32 = 0, blueTotal:UInt32 = 0
        
        for index in stride(from: 0, to: binCount, by: 1) {
            let blue = dataPointer[index]
//            if index > 5 { blueTotal += blue }
            blueBins.append(HistogramBin(value: blue, index: index, ID: index))
        }
        
        for index in stride(from: binCount, to: binCount * 2, by: 1) {
            let red = dataPointer[index]
//            if index > binCount + 5 {greenTotal += green}
            redBins.append(HistogramBin(value: red, index: index - binCount, ID: index))
        }
        
        for index in stride(from: binCount * 2, to: binCount * 3, by: 1) {
            let green = dataPointer[index]
//            if index > binCount * 2 + 5 {redTotal += red}
            greenBins.append(HistogramBin(value:green, index: index - binCount * 2, ID: index))
        }
        
        return Histogram(maxValue: UInt32(width * height), redBins: redBins, greenBins: greenBins, blueBins: blueBins)
    }
}

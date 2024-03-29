//
//  HistogramGenerator.swift
//  Mocca
//
//  Created by David Fearon on 21/10/2020.
//

import Foundation
import MetalPerformanceShaders
import AVFoundation

struct HistogramBin {
    let value: UInt32
    let index: Int
    let ID: Int
    init(value: UInt32, index: Int, ID: Int) {
        self.value = value
        self.index = index
        self.ID = ID
    }
    
    static func empty() -> Self {
        return HistogramBin(value: 0, index: 0, ID: 0)
    }
}

protocol HistogramContract {
    var maxValue: UInt32 { get }
    var redBins: [HistogramBin] { get }
    var greenBins: [HistogramBin] { get }
    var blueBins: [HistogramBin] { get }
}

struct Histogram: HistogramContract {
    let maxValue: UInt32
    let redBins: [HistogramBin]
    let greenBins: [HistogramBin]
    let blueBins: [HistogramBin]
}

protocol HistogramGeneratorContract {
    func generate(sampleBuffer: SampleBuffer) -> HistogramContract?
}

class HistogramGenerator: HistogramGeneratorContract {

    private let metalDevice: MTLDevice?
    private let commandQueue: MTLCommandQueue
    private let commandBuffer: MTLCommandBuffer
    private let binCount: Int
    private var redBins:   [HistogramBin]
    private var greenBins: [HistogramBin]
    private var blueBins:  [HistogramBin]
    
    required init?(metalDevice: MTLDevice?, binCount: Int = 128) {
        
        guard let commandQueue = metalDevice?.makeCommandQueue() else {
            return nil
        }
        
        guard let buffer = commandQueue.makeCommandBuffer() else {
            return nil
        }
        
        if buffer.retainedReferences == false {
            print("Warning: Buffer is not retaining references")
        }
        
        self.commandQueue = commandQueue
        self.commandBuffer = buffer
        self.metalDevice = metalDevice
        self.binCount = binCount
        self.redBins = Array(repeating: HistogramBin.empty(), count: binCount)
        self.greenBins = Array(repeating: HistogramBin.empty(), count: binCount)
        self.blueBins = Array(repeating: HistogramBin.empty(), count: binCount)
    }
    
    func generate(sampleBuffer: SampleBuffer) -> HistogramContract? {

        guard
            let mtlDevice = self.metalDevice,
            let sampleBuffer = guardedBufferCast(sampleBuffer),
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else {
            return nil
        }
        
        var mtlTextureCache : CVMetalTextureCache?
        CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, mtlDevice, nil, &mtlTextureCache)
        
        guard let mtlTextureCache else {
            return nil
        }
        
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        var textureRef : CVMetalTexture?
        CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, mtlTextureCache, imageBuffer, nil, MTLPixelFormat.bgra8Unorm, width, height, 0, &textureRef)
        
        guard
            let textureRef,
            let imageTexture = CVMetalTextureGetTexture(textureRef)
        else {
            return nil
        }
        
        var histogramInfo = MPSImageHistogramInfo(numberOfHistogramEntries: binCount,
                                                  histogramForAlpha: false,
                                                  minPixelValue: vector_float4(0,0,0,0),
                                                  maxPixelValue: vector_float4(1,1,1,1))
        
        let histogram = MPSImageHistogram(device: mtlDevice,
                                          histogramInfo: &histogramInfo)
        
        let bufferLength = histogram.histogramSize(forSourceFormat: imageTexture.pixelFormat)
        
        guard
            let histogramResults = mtlDevice.makeBuffer(length: bufferLength, options: [.storageModeShared]),
            let buffer = self.commandQueue.makeCommandBuffer()
        else {
            return nil
        }
        
        histogram.encode(to: buffer,
                         sourceTexture: imageTexture,
                         histogram: histogramResults,
                         histogramOffset: 0)
        
        buffer.commit()
        buffer.waitUntilCompleted()
        
        let dataPointer = histogramResults.contents().assumingMemoryBound(to: UInt32.self)
        
        var maxValue: UInt32 = 0
        
        for index in 0..<binCount {
            let red = dataPointer[index]
            redBins[index] = HistogramBin(value: red, index: index, ID: index)
            if red > maxValue { maxValue = red }
        }
        
        for index in binCount..<(binCount * 2) {
            let green = dataPointer[index]
            greenBins[index - binCount] = HistogramBin(value: green, index: index - binCount, ID: index)
            if green > maxValue { maxValue = green }
        }
        
        for index in (binCount * 2)..<(binCount * 3) {
            let blue = dataPointer[index]
            blueBins[index - binCount * 2] = HistogramBin(value:blue, index: index - binCount * 2, ID: index)
            if blue > maxValue { maxValue = blue }
        }
        
        return Histogram(maxValue: maxValue, redBins: redBins, greenBins: greenBins, blueBins: blueBins)
    }
}

extension HistogramGenerator {
    
    // Credit: https://stackoverflow.com/a/43927394/2201154
    func guardedBufferCast<T>(_ value: T) -> CMSampleBuffer? {
        guard CFGetTypeID(value as CFTypeRef) == CMSampleBuffer.self.typeID else {
            return nil
        }
        return (value as! CMSampleBuffer)
    }
}

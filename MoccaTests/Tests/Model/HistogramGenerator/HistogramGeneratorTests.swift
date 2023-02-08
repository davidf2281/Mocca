//
//  HistogramGeneratorTests.swift
//  MoccaTests
//
//  Created by David Fearon on 08/02/2023.
//

import XCTest
@testable import Mocca

final class HistogramGeneratorTests: XCTestCase {

    func testHistogramGeneration() throws {
        guard let mtlDevice = MTLCreateSystemDefaultDevice() else {
            XCTFail("Couldn't create metal device")
            return
        }
        
        let sut = HistogramGenerator(mtlDevice: mtlDevice, binCount: 256)
        
        guard let buffer = mockCMSampleBuffer() else {
            XCTFail("Mock sample buffer is nil")
            return
        }
        
        guard let result = sut?.generate(sampleBuffer: buffer) else {
            XCTFail("Histogram generate() returned nil")
            return
        }
        
        // For each colour we expect bins |index : value| to be
        // 0 : 667333, 64: 110889, 128: 110889, 255: 110889
        
        XCTAssertEqual(result.redBins[0].value, 667333)
        XCTAssertEqual(result.greenBins[0].value, 667333)
        XCTAssertEqual(result.blueBins[0].value, 667333)

        XCTAssertEqual(result.redBins[64].value, 110889)
        XCTAssertEqual(result.greenBins[64].value, 110889)
        XCTAssertEqual(result.blueBins[64].value, 110889)
        
        XCTAssertEqual(result.redBins[128].value, 110889)
        XCTAssertEqual(result.greenBins[128].value, 110889)
        XCTAssertEqual(result.blueBins[128].value, 110889)
        
        XCTAssertEqual(result.redBins[255].value, 110889)
        XCTAssertEqual(result.greenBins[255].value, 110889)
        XCTAssertEqual(result.blueBins[255].value, 110889)
        
        // For bins at other indices we expect values to be 0
        let otherRedBins = result.redBins.filter {
            !([0, 64, 128, 255].contains($0.index))
        }
        
        let otherGreenBins = result.greenBins.filter {
            !([0, 64, 128, 255].contains($0.index))
        }
        
        let otherBlueBins = result.blueBins.filter {
            !([0, 64, 128, 255].contains($0.index))
        }
        
        for redBin in otherRedBins {
            XCTAssertEqual(redBin.value, 0)
        }

        for blueBin in otherBlueBins {
            XCTAssertEqual(blueBin.value, 0)
        }
        
        for greenBin in otherGreenBins {
            XCTAssertEqual(greenBin.value, 0)
        }
    }
}

private extension HistogramGeneratorTests {
    
    func uiImage(from sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        let ciimage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciimage, from: ciimage.extent) else {
            return nil
        }
        let image = UIImage(cgImage: cgImage)
        return image
    }
    
    func mockCMSampleBuffer() -> CMSampleBuffer? {
        
        var pixelBuffer: CVPixelBuffer?
        
        let width = 1000
        let height = 1000
        
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, [kCVPixelBufferMetalCompatibilityKey : true] as CFDictionary, &pixelBuffer)
        
        guard let pixelBuffer else {
            return nil
        }
        
        let lockResult = CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        guard lockResult == kCVReturnSuccess else {
            return nil
        }
        
        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            return nil
        }
        
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: baseAddress,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo:bitmapInfo)
        else {
            return nil
        }
        
        // Create a 3x3 grid-style fill pattern with horizontal bright, mid and dark stripes of r, g & b
        let rectWidth = width / 3
        let rectHeight = height / 3
        
        let topLeftRect = CGRect(x: 0, y: 0, width: rectWidth, height: rectHeight)
        let topMiddleRect = CGRect(x: rectWidth, y: 0, width: rectWidth, height: rectHeight)
        let topRightRect = CGRect(x: rectWidth * 2, y: 0, width: rectWidth, height: rectHeight)
        let middleLeftRect = CGRect(x: 0, y: rectHeight, width: rectWidth, height: rectHeight)
        let middleMiddleRect = CGRect(x: rectWidth, y: rectHeight, width: rectWidth, height: rectHeight)
        let middleRightRect = CGRect(x: rectWidth * 2, y: rectHeight, width: rectWidth, height: rectHeight)
        let bottomLeftRect = CGRect(x: 0, y: rectHeight * 2, width: rectWidth, height: rectHeight)
        let bottomMiddleRect = CGRect(x: rectWidth, y:  rectHeight * 2, width: rectWidth, height: rectHeight)
        let bottomRightRect = CGRect(x: rectWidth * 2, y:  rectHeight * 2, width: rectWidth, height: rectHeight)
        
        context.setFillColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        context.fill([topLeftRect])
        context.setFillColor(red: 0.5, green: 0, blue: 0, alpha: 1.0)
        context.fill([topMiddleRect])
        context.setFillColor(red: 0.25, green: 0, blue: 0, alpha: 1.0)
        context.fill([topRightRect])

        context.setFillColor(red: 0, green: 1, blue: 0, alpha: 1.0)
        context.fill([middleLeftRect])
        context.setFillColor(red: 0, green: 0.5, blue: 0, alpha: 1.0)
        context.fill([middleMiddleRect])
        context.setFillColor(red: 0, green: 0.25, blue: 0, alpha: 1.0)
        context.fill([middleRightRect])
        
        context.setFillColor(red: 0, green: 0, blue: 1, alpha: 1.0)
        context.fill([bottomLeftRect])
        context.setFillColor(red: 0, green: 0, blue: 0.5, alpha: 1.0)
        context.fill([bottomMiddleRect])
        context.setFillColor(red: 0, green: 0, blue: 0.25, alpha: 1.0)
        context.fill([bottomRightRect])
        context.flush()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        var info = CMSampleTimingInfo()
        info.presentationTimeStamp = CMTime.zero
        info.duration = CMTime.zero
        info.decodeTimeStamp = CMTime.zero
        
        var formatDesc: CMFormatDescription?
        CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                     imageBuffer: pixelBuffer,
                                                     formatDescriptionOut: &formatDesc)
        
        var sampleBuffer: CMSampleBuffer?
        
        CMSampleBufferCreateReadyWithImageBuffer(allocator: kCFAllocatorDefault,
                                                 imageBuffer: pixelBuffer,
                                                 formatDescription: formatDesc!,
                                                 sampleTiming: &info,
                                                 sampleBufferOut: &sampleBuffer)
        return sampleBuffer
    }
}

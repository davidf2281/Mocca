//
//  HistogramViewModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 09/02/2023.
//

import XCTest
@testable import Mocca

final class HistogramViewModelTests: XCTestCase {
    
    func testHistogramGeneratedOnThirdProcessCall() throws {
        
        let expectation = self.expectation(description: "testSampleBufferDelegateCall")
        
        let mockHistogramGenerator = MockHistogramGenerator()
        let mockSampleBuffer1 = MockSampleBuffer()
        let mockSampleBuffer2 = MockSampleBuffer()
        let mockSampleBuffer3 = MockSampleBuffer()

        let sut = HistogramViewModel(histogramGenerator: mockHistogramGenerator)
        
        sut.processSampleBuffer(mockSampleBuffer1)
        sut.processSampleBuffer(mockSampleBuffer2)
        sut.processSampleBuffer(mockSampleBuffer3)

        DispatchQueue.main.async {
            XCTAssertEqual(mockHistogramGenerator.generateSampleBufferCallCount, 1)
            XCTAssert(mockHistogramGenerator.lastSampleBuffer === mockSampleBuffer3)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}

fileprivate class MockHistogramGenerator: HistogramGeneratorContract {
    
    var generateSampleBufferCallCount = 0
    var lastSampleBuffer: CMSampleBufferContract?
    func generate(sampleBuffer: CMSampleBufferContract) -> Mocca.Histogram? {
        generateSampleBufferCallCount += 1
        lastSampleBuffer = sampleBuffer
        return nil
    }
}

fileprivate class MockSampleBuffer: CMSampleBufferContract {}

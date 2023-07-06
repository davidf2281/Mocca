//
//  HistogramViewModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 09/02/2023.
//

import XCTest
import Combine
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
    
    func testBinPaths() throws {
        let expectation = expectation(description: "testBinPaths")
        var cancellables = Set<AnyCancellable>()
        let mockHistogram = MockHistogram()
        let mockGenerator = MockHistogramGenerator()
        mockGenerator.histogramToReturn = mockHistogram
        
        let mockSampleBuffer1 = MockSampleBuffer()

        let sut = HistogramViewModel(histogramGenerator: mockGenerator, processEvery: 1)
        
        sut.$binPaths.sink { binPaths in
            if let _ = binPaths {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        XCTAssertNil(sut.binPaths) // Check initial conditions
        sut.processSampleBuffer(mockSampleBuffer1)
        waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(sut.binPaths)
        XCTAssertEqual(sut.binPaths?.red.count, 10)
        XCTAssertEqual(sut.binPaths?.green.count, 10)
        XCTAssertEqual(sut.binPaths?.blue.count, 10)
    }
}

fileprivate class MockHistogramGenerator: HistogramGeneratorContract {
    
    var generateSampleBufferCallCount = 0
    var lastSampleBuffer: SampleBuffer?
    var histogramToReturn = MockHistogram()
    func generate(sampleBuffer: SampleBuffer) -> HistogramContract? {
        generateSampleBufferCallCount += 1
        lastSampleBuffer = sampleBuffer
        return histogramToReturn
    }
}

fileprivate class MockSampleBuffer: SampleBuffer {}

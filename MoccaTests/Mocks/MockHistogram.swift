//
//  MockHistogram.swift
//  MoccaTests
//
//  Created by David Fearon on 01/07/2023.
//

import Foundation

class MockHistogram: HistogramContract {
    var maxValue: UInt32 = 100
    var redBins: [HistogramBin] = [
        HistogramBin(value: 0, index: 0, ID: 0),
        HistogramBin(value: 100, index: 1, ID: 1),
        HistogramBin(value: 50, index: 2, ID: 2),
        HistogramBin(value: 25, index: 3, ID: 3),
        HistogramBin(value: 0, index: 4, ID: 4),
        HistogramBin(value: 0, index: 5, ID: 5),
        HistogramBin(value: 0, index: 6, ID: 6),
        HistogramBin(value: 0, index: 7, ID: 7),
        HistogramBin(value: 0, index: 8, ID: 8),
        HistogramBin(value: 0, index: 9, ID: 9)
    ]
    var greenBins: [HistogramBin] = [
        HistogramBin(value: 0, index: 0, ID: 10),
        HistogramBin(value: 0, index: 1, ID: 11),
        HistogramBin(value: 0, index: 2, ID: 12),
        HistogramBin(value: 0, index: 3, ID: 13),
        HistogramBin(value: 0, index: 4, ID: 14),
        HistogramBin(value: 10, index: 5, ID: 15),
        HistogramBin(value: 20, index: 6, ID: 16),
        HistogramBin(value: 30, index: 7, ID: 17),
        HistogramBin(value: 0, index: 8, ID: 18),
        HistogramBin(value: 0, index: 9, ID: 19)
    ]
    
    var blueBins: [HistogramBin] = [
        HistogramBin(value: 100, index: 0, ID: 20),
        HistogramBin(value: 100, index: 1, ID: 21),
        HistogramBin(value: 50, index: 2, ID: 22),
        HistogramBin(value: 25, index: 3, ID: 23),
        HistogramBin(value: 0, index: 4, ID: 24),
        HistogramBin(value: 0, index: 5, ID: 25),
        HistogramBin(value: 0, index: 6, ID: 26),
        HistogramBin(value: 0, index: 7, ID: 27),
        HistogramBin(value: 20, index: 8, ID: 28),
        HistogramBin(value: 30, index: 9, ID: 29)
    ]
}

//
//  HistogramViewModel.swift
//  Mocca
//
//  Created by David Fearon on 21/10/2020.
//

import Foundation

protocol HistogramViewModel: ObservableObject {
    var histogram: Histogram? { get }
}

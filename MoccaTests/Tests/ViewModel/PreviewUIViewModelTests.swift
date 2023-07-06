//
//  PreviewUIViewModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 01/07/2023.
//

import XCTest
@testable import Mocca
final class PreviewUIViewModelTests: XCTestCase {

    func testBackgroundColor() throws {
        let sut = PreviewUIViewModel()
        
        XCTAssertEqual(sut.backgroundColor, UIColor.black)
    }
}

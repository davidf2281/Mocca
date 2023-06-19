//
//  CameraErrorViewModeTests.swift
//  MoccaTests
//
//  Created by David Fearon on 30/06/2023.
//

import XCTest
import SwiftUI
@testable import Mocca

final class CameraErrorViewModeTests: XCTestCase {

    var sut: CameraErrorViewModel!
    
    override func setUp() {
        sut = CameraErrorViewModel()
    }
    
    func testDisplayText() {
        XCTAssertEqual(sut.displayText, "Oh, hey!\n\nLooks like something went wrong\nand your camera failed to start. Sorry.\n\nTry restarting the app.")
    }
    
    func testTextColor() throws {
        XCTAssertEqual(sut.textColor, Color(.sRGB, red: 0.3, green: 0.3, blue: 0.3, opacity: 1))
    }
}

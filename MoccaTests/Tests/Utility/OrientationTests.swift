//
//  OrientationTests.swift
//  MoccaTests
//
//  Created by David Fearon on 09/10/2020.
//

import XCTest
import UIKit
import AVFoundation

@testable import Mocca
class OrientationTests: XCTestCase {

    func testAVOrientationForUIOrientation() {
        XCTAssertEqual(Orientation.avOrientation(for: .portrait), .portrait)
        XCTAssertEqual(Orientation.avOrientation(for: .landscapeLeft), .landscapeLeft)
        XCTAssertEqual(Orientation.avOrientation(for: .landscapeRight), .landscapeRight)
        XCTAssertEqual(Orientation.avOrientation(for: .portraitUpsideDown), .portraitUpsideDown)
    }
    
    func testUIInterfaceOrientationForAVOrientation() {
        XCTAssertEqual(Orientation.uiInterfaceOrientation(for: .landscapeLeft), .landscapeLeft)
        XCTAssertEqual(Orientation.uiInterfaceOrientation(for: .landscapeRight), .landscapeRight)
        XCTAssertEqual(Orientation.uiInterfaceOrientation(for: .portrait), .portrait)
        XCTAssertEqual(Orientation.uiInterfaceOrientation(for: .portraitUpsideDown), .portraitUpsideDown)
    }
}

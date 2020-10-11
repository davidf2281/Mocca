//
//  OrientationTests.swift
//  MoccaTests
//
//  Created by David Fearon on 09/10/2020.
//

import XCTest
@testable import Mocca
class OrientationTests: XCTestCase {

    func testAVOrientationForUIOrientation() {
        XCTAssertEqual(Orientation.AVOrientation(for: UIInterfaceOrientation.portrait), AVCaptureVideoOrientation.portrait)
        XCTAssertEqual(Orientation.AVOrientation(for: UIInterfaceOrientation.landscapeLeft), AVCaptureVideoOrientation.landscapeLeft)
        XCTAssertEqual(Orientation.AVOrientation(for: UIInterfaceOrientation.landscapeRight), AVCaptureVideoOrientation.landscapeRight)
        XCTAssertEqual(Orientation.AVOrientation(for: UIInterfaceOrientation.portraitUpsideDown), AVCaptureVideoOrientation.portraitUpsideDown)
    }
}

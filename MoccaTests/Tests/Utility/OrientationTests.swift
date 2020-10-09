//
//  OrientationTests.swift
//  MoccaTests
//
//  Created by David Fearon on 09/10/2020.
//

import XCTest
@testable import Mocca
class OrientationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testAVOrientationForUIOrientation() {
        XCTAssertEqual(Orientation.AVOrientation(for: UIInterfaceOrientation.portrait), AVCaptureVideoOrientation.portrait)
        XCTAssertEqual(Orientation.AVOrientation(for: UIInterfaceOrientation.landscapeLeft), AVCaptureVideoOrientation.landscapeLeft)
        XCTAssertEqual(Orientation.AVOrientation(for: UIInterfaceOrientation.landscapeRight), AVCaptureVideoOrientation.landscapeRight)
        XCTAssertEqual(Orientation.AVOrientation(for: UIInterfaceOrientation.portraitUpsideDown), AVCaptureVideoOrientation.portraitUpsideDown)
    }
}

//
//  FocusSettingTests.swift
//  MoccaTests
//
//  Created by David Fearon on 30/06/2023.
//

import XCTest

final class FocusSettingTests: XCTestCase {

    func testDefaults() throws {
        let sut = FocusSetting()
        XCTAssertEqual(sut.value, 0.5)
        XCTAssertEqual(sut.settingState, .active)
    }
}

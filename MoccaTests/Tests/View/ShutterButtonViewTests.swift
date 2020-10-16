//
//  ContentViewTests.swift
//  MoccaTests
//
//  Created by David Fearon on 16/10/2020.
//

import XCTest
import SwiftUI

@testable import Mocca
import ViewInspector

extension ShutterButtonView: Inspectable { }

final class ShutterButtonViewTests: XCTestCase {

    private var viewModel = MockShutterButtonViewModel()
    
    override func setUp() {
        viewModel = MockShutterButtonViewModel()
    }

    func testInitialConditions() {
        XCTAssertEqual(viewModel.state, .ready)
    }
    
    func testOuterCircleColorIsGray() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        
        let value = try sut.inspect().zStack().shape(0).foregroundColor()
        XCTAssertEqual(value, Color.gray)
    }
    
    func testOuterCircleStyleIsSolidWhenReady() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)

        let solidStroke = StrokeStyle( lineWidth: 3)
        let value = try sut.inspect().zStack().shape(0).strokeStyle()
        XCTAssertEqual(value, solidStroke)
    }
    
    func testOuterCircleStyleIsDashedWhenCapturePending() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
                
        let dashedStroke = StrokeStyle( lineWidth: 3, dash: [10] )
        viewModel.state = .capturePending
        let value = try sut.inspect().zStack().shape(0).strokeStyle()
        XCTAssertEqual(value, dashedStroke)
    }
}

class MockShutterButtonViewModel: ShutterButtonViewModelProtocol {
    
    var state: PhotoTakerState = .ready
    
    func tapped() {}
}

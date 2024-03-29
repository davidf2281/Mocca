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

private class MockShutterButtonViewModel: ShutterButtonViewModelContract {
    var state: PhotoTakerState = .ready
    var tappedCallCount = 0
    func tapped() {
        tappedCallCount += 1
    }
}

final class ShutterButtonViewTests: XCTestCase {

    private var viewModel: MockShutterButtonViewModel!
    private let dashedStroke = StrokeStyle( lineWidth: 3, dash: [10] )
    private let solidStroke = StrokeStyle( lineWidth: 3)

    override func setUp() {
        viewModel = MockShutterButtonViewModel()
    }

    func testInitialConditions() {
        XCTAssertEqual(viewModel.state, .ready)
    }
    
    func testViewModelTappedCalledOnTap() throws {
        XCTAssertEqual(viewModel.tappedCallCount, 0)
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        try sut.inspect().zStack().callOnTapGesture()
        XCTAssertEqual(viewModel.tappedCallCount, 1)
    }
    
    func testOuterCircleColorIsGray() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        let value = try sut.inspect().zStack().shape(0).foregroundColor()
        XCTAssertEqual(value, Color.gray)
    }
    
    func testOuterCircleStyleIsSolidWhenStateIsReady() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        let value = try sut.inspect().zStack().shape(0).strokeStyle()
        XCTAssertEqual(value, solidStroke)
    }
    
    func testOuterCircleStyleIsDashedWhenStateIsCapturePending() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        viewModel.state = .capturePending
        let value = try sut.inspect().zStack().shape(0).strokeStyle()
        XCTAssertEqual(value, dashedStroke)
    }
    
    func testOuterCircleStyleIsDashedWhenStateIsSaving() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        viewModel.state = .saving
        let value = try sut.inspect().zStack().shape(0).strokeStyle()
        XCTAssertEqual(value, dashedStroke)
    }
    
    func testOuterCircleStyleIsSolidWhenStateIsCaptureError() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        viewModel.state = .error(.captureError)
        let value = try sut.inspect().zStack().shape(0).strokeStyle()
        XCTAssertEqual(value, solidStroke)
    }
    
    func testOuterCircleStyleIsSolidWhenStateIsSaveError() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        viewModel.state = .error(.saveError)
        let value = try sut.inspect().zStack().shape(0).strokeStyle()
        XCTAssertEqual(value, solidStroke)
    }

    func testOuterCircleFrameSize() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)

        let value = try sut.inspect().zStack().shape(0).fixedFrame()
        XCTAssertEqual(value.width,  65)
        XCTAssertEqual(value.height, 65)
    }
    
    func testInnerCircleFrameSize() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)

        let value = try sut.inspect().zStack().shape(1).fixedFrame()
        XCTAssertEqual(value.width,  50)
        XCTAssertEqual(value.height, 50)
    }

    func testInnerCircleIsRedWhenStateIsReady() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)

        let value = try sut.inspect().zStack().shape(1).fillShapeStyle(Color.self)

        XCTAssertEqual(value, .red)
    }
    
    func testInnerCircleIsGrayWhenStateIsCaptureError() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        viewModel.state = .error(.captureError)
        let value = try sut.inspect().zStack().shape(1).fillShapeStyle(Color.self)
        XCTAssertEqual(value, .gray)
    }
    
    func testInnerCircleIsGrayWhenStateIsCapturePending() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        viewModel.state = .capturePending
        let value = try sut.inspect().zStack().shape(1).fillShapeStyle(Color.self)
        XCTAssertEqual(value, .gray)
    }
    
    func testInnerCircleIsGrayWhenStateIsSaveError() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        viewModel.state = .error(.saveError)
        let value = try sut.inspect().zStack().shape(1).fillShapeStyle(Color.self)
        XCTAssertEqual(value, .gray)
    }
    
    func testInnerCircleIsGrayWhenStateIsSaving() throws {
        let sut = ShutterButtonView<MockShutterButtonViewModel>(viewModel: viewModel)
        viewModel.state = .saving
        let value = try sut.inspect().zStack().shape(1).fillShapeStyle(Color.self)
        XCTAssertEqual(value, .gray)
    }
}



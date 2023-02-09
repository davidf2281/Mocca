//
//  ViewConversionTests.swift
//  MoccaTests
//
//  Created by David Fearon on 09/02/2023.
//

import XCTest
@testable import Mocca

final class ViewConversionTests: XCTestCase {

    private let frameWidth: CGFloat = 768
    private let frameHeight: CGFloat = 1280
    private let xPosition: CGFloat = 100
    private let yPosition: CGFloat = 50
    private var position: CGPoint { CGPoint (x: xPosition, y: yPosition) }
    private var parentFrame: CGSize { CGSize(width: frameWidth, height: frameHeight) }
    private let translationWidth: CGFloat = 100
    private let translationHeight: CGFloat = 50
    private var translation: CGSize { CGSize(width: translationWidth, height: translationHeight) }
    
    func testDisplayPositionForPortraitOrientation() {
        
        let orientation: UIInterfaceOrientation = .portrait
        
        let expectedResult = CGPoint(x: xPosition, y: yPosition)
        
        let sut = ViewConversion.displayPosition(position: position, orientation: orientation, parentFrame: parentFrame)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testDisplayPositionForPortraitUpsideDownOrientation() {
        
        let orientation: UIInterfaceOrientation = .portraitUpsideDown
        
        let expectedResult = CGPoint(x: xPosition, y: yPosition)
        
        let sut = ViewConversion.displayPosition(position: position, orientation: orientation, parentFrame: parentFrame)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testDisplayPositionForLandscapeLeftOrientation() {
        
        let orientation: UIInterfaceOrientation = .landscapeLeft
        
        let expectedResult = CGPoint(x: frameWidth - yPosition, y: xPosition)
        
        let sut = ViewConversion.displayPosition(position: position, orientation: orientation, parentFrame: parentFrame)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testDisplayPositionForLandscapeRightOrientation() {
        
        let orientation: UIInterfaceOrientation = .landscapeRight
        
        let expectedResult = CGPoint(x: yPosition, y: frameHeight - xPosition)
        
        let sut = ViewConversion.displayPosition(position: position, orientation: orientation, parentFrame: parentFrame)
        
        XCTAssertEqual(sut, expectedResult)
    }

    func testTapPositionForPortraitOrientation() throws {
        
        let orientation: UIInterfaceOrientation = .portrait
        
        let expectedResult = CGPoint(x: xPosition, y: yPosition)
        
        let sut = ViewConversion.tapPosition(position: position, orientation: orientation, parentFrame: parentFrame)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testTapPositionForPortraitUpsideDownOrientation() {
        
        let orientation: UIInterfaceOrientation = .portraitUpsideDown
        
        let expectedResult = CGPoint(x: xPosition, y: yPosition)
        
        let sut = ViewConversion.tapPosition(position: position, orientation: orientation, parentFrame: parentFrame)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testTapPositionForLandscapeLeftOrientation() {
        
        let orientation: UIInterfaceOrientation = .landscapeLeft
        
        let expectedResult = CGPoint(x: yPosition, y: frameWidth - xPosition)
        
        let sut = ViewConversion.tapPosition(position: position, orientation: orientation, parentFrame: parentFrame)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testTapPositionForLandscapeRightOrientation() {
        
        let orientation: UIInterfaceOrientation = .landscapeRight
        
        let expectedResult = CGPoint(x: frameHeight - yPosition, y: xPosition)
        
        let sut = ViewConversion.tapPosition(position: position, orientation: orientation, parentFrame: parentFrame)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testTranslationForDragForPortraitOrientation() {
        
        let orientation: UIInterfaceOrientation = .portrait
        
        let expectedResult = CGSize(width: translationWidth, height: translationHeight)
        
        let sut = ViewConversion.translationForDrag(translation: translation, orientation: orientation)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testTranslationForDragForPortraitUpsideDownOrientation() {

        let orientation: UIInterfaceOrientation = .portraitUpsideDown
        
        let expectedResult = CGSize(width: translationWidth, height: translationHeight)
        
        let sut = ViewConversion.translationForDrag(translation: translation, orientation: orientation)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testTranslationForDragForLandscapeLeftOrientation() {

        let orientation: UIInterfaceOrientation = .landscapeLeft
        
        let expectedResult = CGSize(width: translationHeight, height: -translationWidth)
        
        let sut = ViewConversion.translationForDrag(translation: translation, orientation: orientation)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testTranslationForDragForLandscapeRightOrientation() {
        
        let orientation: UIInterfaceOrientation = .landscapeRight
        
        let expectedResult = CGSize(width: -translationHeight, height: translationWidth)
        
        let sut = ViewConversion.translationForDrag(translation: translation, orientation: orientation)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testClampWithoutInset() {
        
        let expectedResult = CGPoint(x: 1000, y: 1200)
        
        let sut = ViewConversion.clamp(position: CGPoint(x: 1200, y: 2000), frame: CGSize(width: 1000, height: 1200), inset: 0)
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testClampWithInset() {
        
        let expectedResult = CGPoint(x: 990, y: 1190)
        
        let sut = ViewConversion.clamp(position: CGPoint(x: 1200, y: 2000), frame: CGSize(width: 1000, height: 1200), inset: 10)
        
        XCTAssertEqual(sut, expectedResult)
    }
}

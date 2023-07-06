//
//  PreviewViewControllerTests.swift
//  MoccaTests
//
//  Created by David Fearon on 01/07/2023.
//

import XCTest

final class PreviewViewControllerTests: XCTestCase {

    var sut: PreviewViewController!
    var viewModel: MockPreviewViewControllerViewModel!
    
    override func setUpWithError() throws {
        viewModel = MockPreviewViewControllerViewModel()
        sut = PreviewViewController(viewModel: viewModel)
    }

    func testInit() throws {
        XCTAssertFalse(sut.view.translatesAutoresizingMaskIntoConstraints)
    }
    
    func testViewDidLoad() throws {
        sut.viewDidLoad()
        XCTAssertEqual(sut.view.backgroundColor, viewModel.backgroundColor)
    }
    
    func testViewDidLayoutSubviews() throws {
        let frame = CGRect(x: 10, y: 20, width: 101, height: 102)
        sut.view.frame = frame
        sut.viewDidLayoutSubviews()
        XCTAssertEqual(viewModel.previewView?.videoPreviewLayer?.frame, frame)
    }
    
    func testViewAnimatesOnWillTransitionToSize() throws {
        let size = CGSize(width: 121, height: 312)
        let coordinator = MockUIViewControllerTransitionCoordinator()
        sut.viewWillTransition(to: size, with: coordinator)
        XCTAssertEqual(coordinator.animateAlongsideCallCount, 1)
    }
}

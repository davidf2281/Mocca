//
//  CameraSelectionViewModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 11/07/2023.
//

import XCTest
@testable import Mocca

final class CameraSelectionViewModelTests: XCTestCase {

    private static let uuid1 = UUID()
    private static let uuid2 = UUID()
    
    var sut: CameraSelectionViewModel!
    var mockCameraSelectionModel: CameraSelectionModel!
    
    override func setUpWithError() throws {
        let mockCameras = [
            PhysicalCamera(id: Self.uuid1, type: .builtInTelephotoCamera, position: .back, captureDevice: MockCaptureDevice()),
            PhysicalCamera(id: Self.uuid1, type: .builtInWideAngleCamera, position: .back, captureDevice: MockCaptureDevice())
        ]
                
        let mockSessionManager = MockSessionManager()
        mockSessionManager.selectedCameraToReturn = mockCameras.first!
        mockSessionManager.activeCamera = mockCameras.first!
         
        mockCameraSelectionModel = CameraSelectionModel(availableCameras: mockCameras, sessionManager: mockSessionManager)
        
        sut = CameraSelectionViewModel(model: mockCameraSelectionModel)
    }

    func testSelectableCameraViewModels() throws {
        let comparisonViewModels = mockCameraSelectionModel.availableCameras.map{ SelectableCameraViewModel(model: $0) }
        XCTAssertEqual(sut.selectableCameraViewModels, comparisonViewModels)
    }
}

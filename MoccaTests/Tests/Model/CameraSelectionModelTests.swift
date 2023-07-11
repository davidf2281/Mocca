//
//  CameraSelectionModelTests.swift
//  MoccaTests
//
//  Created by David Fearon on 11/07/2023.
//

import XCTest
@testable import Mocca

final class CameraSelectionModelTests: XCTestCase {

    private static let uuid1 = UUID()
    private static let uuid2 = UUID()
    
    var sut: CameraSelectionModel!
    var mockCameras: [PhysicalCamera]!
    var mockSessionManager: MockSessionManager!
    
    override func setUpWithError() throws {
        
        mockCameras = [
            PhysicalCamera(id: Self.uuid1, type: .builtInTelephotoCamera, position: .back, captureDevice: MockCaptureDevice()),
            PhysicalCamera(id: Self.uuid1, type: .builtInWideAngleCamera, position: .back, captureDevice: MockCaptureDevice())
        ]
        
        mockSessionManager = MockSessionManager()
        
        sut = CameraSelectionModel(availableCameras: mockCameras, sessionManager: mockSessionManager)
    }

    func testInitialCameraIsSessionManagerActiveCamera() {
        XCTAssertEqual(sut.selectedCamera, mockSessionManager.activeCamera)
    }
    
    func testSelectCamera() {
        let mockCamera = mockCameras.first!
        mockSessionManager.selectedCameraToReturn = mockCamera
        
        sut.selectCamera(cameraID: mockCamera.id)
        
        XCTAssertEqual(sut.selectedCamera, mockCamera)
    }
    
    func testInitFailsOnNilSessionManager() {
        sut = CameraSelectionModel(availableCameras: mockCameras, sessionManager: nil)
        XCTAssertNil(sut)
    }
}

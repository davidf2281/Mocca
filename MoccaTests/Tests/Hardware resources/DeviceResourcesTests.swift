//
//  ConfigurationFactoryTests.swift
//  MoccaTests
//
//  Created by David Fearon on 30/06/2023.
//

import XCTest
@testable import Mocca

final class DeviceResourcesTests: XCTestCase {
    
    var sut: DeviceResources!
    var mockCaptureDevice: MockCaptureDevice!
    
    override func setUpWithError() throws {
        mockCaptureDevice = MockCaptureDevice()
        sut = DeviceResources(captureDevice: mockCaptureDevice)
    }

    func testPhysicalDeviceFromLogicalDevice() throws {
                        
        let logicalCameraDevice = LogicalCameraDevice(type: .builtInUltraWideCamera, position: .front)
        
        let _ = sut.physicalDevice(from: logicalCameraDevice)
        
        XCTAssertEqual(mockCaptureDevice.positionSet, .front)
        XCTAssertEqual(mockCaptureDevice.deviceTypeSet, .builtInUltraWideCamera)
    }
    
    func testAnyAvailableCameraWhenPreferredDeviceAvailable() throws {
        let supportedCameraDevices = [
            LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back),
            LogicalCameraDevice(type: .builtInWideAngleCamera, position: .back),
            LogicalCameraDevice(type: .builtInUltraWideCamera, position: .back)
        ]
        
        let preferredDevice = LogicalCameraDevice(type: .builtInWideAngleCamera, position: .back)
        
        mockCaptureDevice.captureDeviceToReturn = mockCaptureDevice

        let result = sut.anyAvailableCamera(preferredDevice: preferredDevice, supportedCameraDevices: supportedCameraDevices)
        
        XCTAssertEqual(mockCaptureDevice.positionSet, .back)
        XCTAssertEqual(mockCaptureDevice.deviceTypeSet, .builtInWideAngleCamera)
        XCTAssertIdentical(result, mockCaptureDevice)
    }
    
    func testAnyAvailableCameraWhenPreferredDeviceNotAvailable() throws {
        let supportedCameraDevices = [
            LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back),
            LogicalCameraDevice(type: .builtInUltraWideCamera, position: .back)
        ]
        
        let preferredDevice = LogicalCameraDevice(type: .builtInWideAngleCamera, position: .back)
                
        mockCaptureDevice.captureDeviceToReturn = mockCaptureDevice

        let _ = sut.anyAvailableCamera(preferredDevice: preferredDevice, supportedCameraDevices: supportedCameraDevices)
        
        XCTAssertEqual(mockCaptureDevice.positionSet, .back)
        XCTAssertEqual(mockCaptureDevice.deviceTypeSet, .builtInTelephotoCamera)
    }
    
    func testAnyAvailableCameraWhenNoSupportedDevicesAvailable() throws {
        let supportedCameraDevices = [
            LogicalCameraDevice(type: .builtInTelephotoCamera, position: .back),
            LogicalCameraDevice(type: .builtInUltraWideCamera, position: .back)
        ]
        
        let preferredDevice = LogicalCameraDevice(type: .builtInWideAngleCamera, position: .back)
                
        mockCaptureDevice.captureDeviceToReturn = nil

        let result = sut.anyAvailableCamera(preferredDevice: preferredDevice, supportedCameraDevices: supportedCameraDevices)
        
        XCTAssertNil(result)
    }
}

/*
class MockMTLDevice: NSObject, MTLDevice {
    var name: String = "Mock MTLDevice"
    var registryID: UInt64 = 0
    var maxThreadsPerThreadgroup: MTLSize = .init(width: 0, height: 0, depth: 0)
    var hasUnifiedMemory: Bool = false
    var readWriteTextureSupport: MTLReadWriteTextureTier = .tierNone
    var argumentBuffersSupport: MTLArgumentBuffersTier = .tier1
    var areRasterOrderGroupsSupported: Bool = false
    var supports32BitFloatFiltering: Bool = false
    var supports32BitMSAA: Bool = false
    var supportsQueryTextureLOD: Bool = false
    var supportsBCTextureCompression: Bool = false
    var supportsPullModelInterpolation: Bool = false
    var areBarycentricCoordsSupported: Bool = false
    var supportsShaderBarycentricCoordinates: Bool = false
    var currentAllocatedSize: Int = 0
    
    func makeCommandQueue() -> MTLCommandQueue? { nil }
    func makeCommandQueue(maxCommandBufferCount: Int) -> MTLCommandQueue? { nil }
    func heapTextureSizeAndAlign(descriptor desc: MTLTextureDescriptor) -> MTLSizeAndAlign { .init(size: 0, align: 0) }
    func heapBufferSizeAndAlign(length: Int, options: MTLResourceOptions = []) -> MTLSizeAndAlign { .init(size: 0, align: 0) }
    func makeHeap(descriptor: MTLHeapDescriptor) -> MTLHeap? { nil }
    func makeBuffer(length: Int, options: MTLResourceOptions = []) -> MTLBuffer? { nil }
    func makeBuffer(bytes pointer: UnsafeRawPointer, length: Int, options: MTLResourceOptions = []) -> MTLBuffer? { nil }
    func makeBuffer(bytesNoCopy pointer: UnsafeMutableRawPointer, length: Int, options: MTLResourceOptions = [], deallocator: ((UnsafeMutableRawPointer, Int) -> Void)? = nil) -> MTLBuffer? { nil }
    func makeDepthStencilState(descriptor: MTLDepthStencilDescriptor) -> MTLDepthStencilState? { nil  }
    func makeTexture(descriptor: MTLTextureDescriptor) -> MTLTexture? { nil }
    func makeTexture(descriptor: MTLTextureDescriptor, iosurface: IOSurfaceRef, plane: Int) -> MTLTexture? { nil }
    func makeSamplerState(descriptor: MTLSamplerDescriptor) -> MTLSamplerState? { nil }
    func makeDefaultLibrary() -> MTLLibrary? { nil  }
    func makeDefaultLibrary(bundle: Bundle) throws -> MTLLibrary {
        // TODO:
    }
    
    func makeFence() -> MTLFence? { nil }
    
    func supportsFeatureSet(_ featureSet: MTLFeatureSet) -> Bool { false }
    
    func supportsFamily(_ gpuFamily: MTLGPUFamily) -> Bool { false }
    
    func supportsTextureSampleCount(_ sampleCount: Int) -> Bool { false }
    
    func minimumLinearTextureAlignment(for format: MTLPixelFormat) -> Int { 0 }
    
    func minimumTextureBufferAlignment(for format: MTLPixelFormat) -> Int { 0 }
    
    func __newRenderPipelineState(withMeshDescriptor descriptor: MTLMeshRenderPipelineDescriptor, options: MTLPipelineOption, reflection: AutoreleasingUnsafeMutablePointer<MTLAutoreleasedRenderPipelineReflection?>?) throws -> MTLRenderPipelineState {
        // TODO:
    }
    
    var maxThreadgroupMemoryLength: Int = 0
    var maxArgumentBufferSamplerCount: Int = 0
    var areProgrammableSamplePositionsSupported: Bool = false
    func __getDefaultSamplePositions(_ positions: UnsafeMutablePointer<MTLSamplePosition>, count: Int) {}
    func makeArgumentEncoder(arguments: [MTLArgumentDescriptor]) -> MTLArgumentEncoder? { nil }
    
    func supportsRasterizationRateMap(layerCount: Int) -> Bool { false }
    
    func makeRasterizationRateMap(descriptor: MTLRasterizationRateMapDescriptor) -> MTLRasterizationRateMap? { nil  }
    
    func makeIndirectCommandBuffer(descriptor: MTLIndirectCommandBufferDescriptor, maxCommandCount maxCount: Int, options: MTLResourceOptions = []) -> MTLIndirectCommandBuffer? {
        nil
    }
    
    func makeEvent() -> MTLEvent? {
        nil
    }
    
    func makeSharedEvent() -> MTLSharedEvent? {
        nil
    }
    
    func makeSharedEvent(handle sharedEventHandle: MTLSharedEventHandle) -> MTLSharedEvent? {
        nil
    }
    
    func sparseTileSize(with textureType: MTLTextureType, pixelFormat: MTLPixelFormat, sampleCount: Int) -> MTLSize {
        .init(width: 0, height: 0, depth: 0)
    }
    
    var sparseTileSizeInBytes: Int = 0
    
    func sparseTileSizeInBytes(sparsePageSize: MTLSparsePageSize) -> Int {
        0
    }
    
    func sparseTileSize(textureType: MTLTextureType, pixelFormat: MTLPixelFormat, sampleCount: Int, sparsePageSize: MTLSparsePageSize) -> MTLSize {
        .init(width: 0, height: 0, depth: 0)
    }
    
    var maxBufferLength: Int = 0
    
    var counterSets: [MTLCounterSet]?
    
    func makeCounterSampleBuffer(descriptor: MTLCounterSampleBufferDescriptor) throws -> MTLCounterSampleBuffer {
        // TODO:
    }
    
    func __sampleTimestamps(_ cpuTimestamp: UnsafeMutablePointer<MTLTimestamp>, gpuTimestamp: UnsafeMutablePointer<MTLTimestamp>) {
        
    }
    
    func makeArgumentEncoder(bufferBinding: MTLBufferBinding) -> MTLArgumentEncoder {
        // TODO:
    }
    
    func supportsCounterSampling(_ samplingPoint: MTLCounterSamplingPoint) -> Bool {
        false
    }
    
    func supportsVertexAmplificationCount(_ count: Int) -> Bool {
        false
    }
    
    var supportsDynamicLibraries: Bool = false
    
    var supportsRenderDynamicLibraries: Bool = false
    
    func makeDynamicLibrary(library: MTLLibrary) throws -> MTLDynamicLibrary {
        // TODO:
    }
    
    func makeDynamicLibrary(url: URL) throws -> MTLDynamicLibrary {
        // TODO
    }
    
    func makeBinaryArchive(descriptor: MTLBinaryArchiveDescriptor) throws -> MTLBinaryArchive {
        // TODO
    }
    
    var supportsRaytracing: Bool = false
    
    func accelerationStructureSizes(descriptor: MTLAccelerationStructureDescriptor) -> MTLAccelerationStructureSizes {
        .init(accelerationStructureSize: 0, buildScratchBufferSize: 0, refitScratchBufferSize: 0)
    }
    
    func makeAccelerationStructure(size: Int) -> MTLAccelerationStructure? {
        nil
    }
    
    func makeAccelerationStructure(descriptor: MTLAccelerationStructureDescriptor) -> MTLAccelerationStructure? {
        nil
    }
    
    func heapAccelerationStructureSizeAndAlign(size: Int) -> MTLSizeAndAlign {
        .init(size: 0, align: 0)
    }
    
    func heapAccelerationStructureSizeAndAlign(descriptor: MTLAccelerationStructureDescriptor) -> MTLSizeAndAlign {
        .init(size: 0, align: 0)
    }
    
    var supportsFunctionPointers: Bool = false
    
    var supportsFunctionPointersFromRender: Bool = false
    
    var supportsRaytracingFromRender: Bool = false
    
    var supportsPrimitiveMotionBlur: Bool = false
}
*/

//
//  LocalLabelStorageTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import RxBlocking
import RxSwift
import XCTest
@testable import Health_House

class LocalLabelStorageTests: XCTestCase {
    
    private lazy var sut = self.makeLocalLabelStorageSUT()
    private var insertedLabel: LabelDomain!
    
    override func setUp() {
        super.setUp()
        let coreDataStorage = self.sut.coreDataStorage
        self.insertedLabel = LabelDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
    }
    
    override func tearDown() {
        self.removeCoreDataStorage()
        super.tearDown()
    }
    
}

extension LocalLabelStorageTests {
    
    func test_fetchAllInCoreData_shouldFetchedInCoreData() throws {
        let result = try self.sut.localLabelStorage
            .fetchAllInCoreData()
            .toBlocking()
            .single()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.contains(self.insertedLabel))
    }
    
    func test_insertIntoCoreData_whenLabelHasCoreID_shouldInsertedIntoCoreData() throws {
        let updatedObject = LabelDomain(coreID: self.insertedLabel.coreID,
                                        createdAt: self.insertedLabel.createdAt,
                                        updatedAt: self.insertedLabel.updatedAt,
                                        name: "Label Updated Test")
        
        let result = try self.sut.localLabelStorage
            .insertIntoCoreData(updatedObject)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(updatedObject.coreID, result.coreID)
        XCTAssertEqual(updatedObject.name, result.name)
    }
    
    func test_insertIntoCoreData_whenLabelHasNotCoreID_shouldInsertedIntoCoreData() throws {
        let insertedObject = LabelDomain.stubElement
        
        let result = try self.sut.localLabelStorage
            .insertIntoCoreData(insertedObject)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(insertedObject.name, result.name)
    }
    
    func test_removeInCoreData_whenLabelInCoreData_thenRemovedInCoreData() throws {
        let removedObject = self.insertedLabel!
        
        let result = try self.sut.localLabelStorage
            .removeInCoreData(removedObject)
            .toBlocking()
            .single()
        
        XCTAssertEqual(removedObject.coreID, result.coreID)
    }
    
    func test_removeInCoreData_whenLabelNotInCoreData_thenThrowsError() throws {
        let removedObject = LabelDomain.stubElement
        
        XCTAssertThrowsError(try self.sut.localLabelStorage
                                .removeInCoreData(removedObject)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [DELETE] -> LocalLabelStorage: Failed to execute removeInCoreData() caused by coreID is not available")
        }
    }
    
}

// MARK: LocalLabelStorageSUT
public struct LocalLabelStorageSUT {
    
    public let semaphore: DispatchSemaphore
    public let disposeBag: DisposeBag
    public let coreDataStorage: CoreDataStorageSharedMock
    public let localLabelStorage: LocalLabelStorage
    
}

public extension XCTest {
    
    func makeLocalLabelStorageSUT() -> LocalLabelStorageSUT {
        let semaphore = self.makeSempahore()
        let disposeBag = self.makeDisposeBag()
        let coreDataStorage = self.makeCoreDataStorageMock()
        let localActivityStorage = DefaultLocalLabelStorage(coreDataStorage: coreDataStorage)
        return LocalLabelStorageSUT(semaphore: semaphore,
                                    disposeBag: disposeBag,
                                    coreDataStorage: coreDataStorage,
                                    localLabelStorage: localActivityStorage)
    }
    
}

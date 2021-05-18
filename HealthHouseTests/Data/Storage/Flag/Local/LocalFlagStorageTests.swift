//
//  LocalFlagStorageTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import RxBlocking
import RxSwift
import XCTest
@testable import Health_House

class LocalFlagStorageTests: XCTestCase {
    
    private lazy var sut = self.makeLocalFlagStorageSUT()
    private var insertedLabel: FlagDomain!
    
    override func setUp() {
        super.setUp()
        let coreDataStorage = self.sut.coreDataStorage
        self.insertedLabel = FlagDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
    }
    
    override func tearDown() {
        self.removeCoreDataStorage()
        super.tearDown()
    }
    
}

extension LocalFlagStorageTests {
    
    func test_fetchAllInCoreData_shouldFetchedInCoreData() throws {
        let result = try self.sut.localLabelStorage
            .fetchAllInCoreData()
            .toBlocking()
            .single()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.contains(self.insertedLabel))
    }
    
    func test_insertIntoCoreData_whenFlagHasCoreID_shouldInsertedIntoCoreData() throws {
        let updatedObject = FlagDomain(coreID: self.insertedLabel.coreID,
                                       createdAt: self.insertedLabel.createdAt,
                                       updatedAt: self.insertedLabel.updatedAt,
                                       hexcolor: "000",
                                       name: "Label Updated Test")
        
        let result = try self.sut.localLabelStorage
            .insertIntoCoreData(updatedObject)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(updatedObject.coreID, result.coreID)
        XCTAssertEqual(updatedObject.name, result.name)
    }
    
    func test_insertIntoCoreData_whenFlagHasNotCoreID_shouldInsertedIntoCoreData() throws {
        let insertedObject = FlagDomain.stubElement
        
        let result = try self.sut.localLabelStorage
            .insertIntoCoreData(insertedObject)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(insertedObject.name, result.name)
    }
    
    func test_removeInCoreData_whenFlagInCoreData_thenRemovedInCoreData() throws {
        let removedObject = self.insertedLabel!
        
        let result = try self.sut.localLabelStorage
            .removeInCoreData(removedObject)
            .toBlocking()
            .single()
        
        XCTAssertEqual(removedObject.coreID, result.coreID)
    }
    
    func test_removeInCoreData_whenFlagNotInCoreData_thenThrowsError() throws {
        let removedObject = FlagDomain.stubElement
        
        XCTAssertThrowsError(try self.sut.localLabelStorage
                                .removeInCoreData(removedObject)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [DELETE] -> LocalFlagStorage: Failed to execute removeInCoreData() caused by coreID is not available")
        }
    }
    
}

// MARK: LocalFlagStorageSUT
public struct LocalFlagStorageSUT {
    
    public let semaphore: DispatchSemaphore
    public let disposeBag: DisposeBag
    public let coreDataStorage: CoreDataStorageSharedMock
    public let localLabelStorage: LocalFlagStorage
    
}

public extension XCTest {
    
    func makeLocalFlagStorageSUT() -> LocalFlagStorageSUT {
        let semaphore = self.makeSempahore()
        let disposeBag = self.makeDisposeBag()
        let coreDataStorage = self.makeCoreDataStorageMock()
        let localActivityStorage = DefaultLocalFlagStorage(coreDataStorage: coreDataStorage)
        return LocalFlagStorageSUT(semaphore: semaphore,
                                   disposeBag: disposeBag,
                                   coreDataStorage: coreDataStorage,
                                   localLabelStorage: localActivityStorage)
    }
    
}
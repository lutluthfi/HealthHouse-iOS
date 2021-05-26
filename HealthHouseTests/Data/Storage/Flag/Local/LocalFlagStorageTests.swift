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
        self.clearCoreDataStorage()
        super.tearDown()
    }
    
}

extension LocalFlagStorageTests {
    
    func test_fetchAllInCoreData_shouldFetchedInCoreData() throws {
        let result = try self.sut.localFlagStorage
            .fetchAllInCoreData()
            .toBlocking()
            .single()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.contains(self.insertedLabel))
    }
    
    func test_insertIntoCoreData_whenFlagHasCoreIDAndNameNoChanges_shouldInsertedIntoCoreData() throws {
        let updatedObject = FlagDomain(coreID: nil,
                                       createdAt: self.insertedLabel.createdAt,
                                       updatedAt: self.insertedLabel.updatedAt,
                                       hexcolor: "000",
                                       name: self.insertedLabel.name)
        
        XCTAssertThrowsError(try self.sut.localFlagStorage
                                .insertIntoCoreData(updatedObject)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [SAVE] -> LocalFlagStorage: Failed to execute insertIntoCoreData() caused by Flag is already created")
        }
    }
    
    func test_insertIntoCoreData_whenFlagHasCoreIDAndNameChanges_shouldInsertedIntoCoreData() throws {
        let updatedObject = FlagDomain(coreID: self.insertedLabel.coreID,
                                       createdAt: self.insertedLabel.createdAt,
                                       updatedAt: self.insertedLabel.updatedAt,
                                       hexcolor: "000",
                                       name: "Label Updated Test")
        
        XCTAssertThrowsError(try self.sut.localFlagStorage
                                .insertIntoCoreData(updatedObject)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [SAVE] -> LocalFlagStorage: Failed to execute insertIntoCoreData() caused by flagCoreID is already exist")
        }
    }
    
    func test_insertIntoCoreData_whenFlagHasNotCoreID_shouldInsertedIntoCoreData() throws {
        let insertedObject = FlagDomain.stubElement
        
        let result = try self.sut.localFlagStorage
            .insertIntoCoreData(insertedObject)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(insertedObject.name, result.name)
    }
    
    func test_removeInCoreData_whenFlagInCoreData_thenRemovedInCoreData() throws {
        let removedObject = self.insertedLabel!
        
        let result = try self.sut.localFlagStorage
            .removeInCoreData(removedObject)
            .toBlocking()
            .single()
        
        XCTAssertEqual(removedObject.coreID, result.coreID)
    }
    
    func test_removeInCoreData_whenFlagNotInCoreData_thenThrowsErrorCausedByNotAvailable() throws {
        let removedObject = FlagDomain.stubElement
        
        XCTAssertThrowsError(try self.sut.localFlagStorage
                                .removeInCoreData(removedObject)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [DELETE] -> LocalFlagStorage: Failed to execute removeInCoreData() caused by coreID is not available")
        }
    }
    
}

// MARK: LocalFlagStorageSUT
struct LocalFlagStorageSUT {
    
    public let semaphore: DispatchSemaphore
    public let disposeBag: DisposeBag
    public let coreDataStorage: CoreDataStorageSharedMock
    public let localFlagStorage: LocalFlagStorage
    
}

extension XCTest {
    
    func makeLocalFlagStorageSUT(coreDataStorage: CoreDataStorageSharedMock = CoreDataStorageMock()) -> LocalFlagStorageSUT {
        let semaphore = self.makeSempahore()
        let disposeBag = self.makeDisposeBag()
        let localActivityStorage = DefaultLocalFlagStorage(coreDataStorage: coreDataStorage)
        return LocalFlagStorageSUT(semaphore: semaphore,
                                   disposeBag: disposeBag,
                                   coreDataStorage: coreDataStorage,
                                   localFlagStorage: localActivityStorage)
    }
    
}

//
//  LocalActivityStorageTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 21/03/21.
//

import CoreData
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Health_House

// MARK: LocalActivityStorageTests
class LocalActivityStorageTests: XCTestCase {

    private lazy var sut = self.makeLocalActivityStorageSUT()
    private var insertedActivities: [ActivityDomain] = []
    private var insertedActivity: ActivityDomain!
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        self.removeStub()
        super.tearDown()
    }
    
    private func makeStub() {
        let stubCollection = ActivityDomain.stubCollectionCoreData(coreDataStorage: self.sut.coreDataStorage)
        let stubElement = ActivityDomain.stubElementCoreData(coreDataStorage: self.sut.coreDataStorage)
        self.insertedActivity = stubElement.0
        self.insertedActivities.append(self.insertedActivity)
        self.insertedActivities.append(contentsOf: stubCollection.0)
        self.insertedActivities.sort { $0.title < $1.title }
    }
    
    private func removeStub() {
        self.removeCoreDataStorage()
    }

}

// MARK: FetchAllActivityInCoreData
extension LocalActivityStorageTests {
    
    func test_fetchAllActivityInCoreData_shouldFetchedInCoreData() throws {
        let timeout = self.sut.coreDataStorage.fetchCollectionTimeout
        
        let result = try self.sut.localActivityStorage
            .fetchAllInCoreData()
            .toBlocking(timeout: timeout)
            .single()
            .sorted { $0.title < $1.title }
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result, self.insertedActivities)
    }
    
}

// MARK: FetchAllActivityInCoreDataOwnedBy
extension LocalActivityStorageTests {
    
    func test_fetchAllActivityInCoreDataOwnedBy_whenProfileHasCoreID_thenFetchedInCoreData() throws {
        let timeout = self.sut.coreDataStorage.fetchCollectionTimeout
        let profile = self.insertedActivity.profile
        
        let result = try self.sut.localActivityStorage
            .fetchAllInCoreData(ownedBy: profile)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result, [self.insertedActivity])
    }
    
    func test_fetchAllActivityInCoreDataOwnedBy_whenProfileHasNotCoreID_thenFetchedInCoreData() throws {
        let timeout = self.sut.coreDataStorage.fetchCollectionTimeout
        let profile = ProfileDomain.stubElement
        
        XCTAssertThrowsError(try self.sut.localActivityStorage
                                .fetchAllInCoreData(ownedBy: profile)
                                .toBlocking(timeout: timeout)
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [DELETE] -> LocalActivityStorage: Failed to execute fetchAllInCoreData(ownedBy:) caused by profileCoreID is not available")
        }
    }
    
}

// MARK: FetchAllActivityInCoreDataOwnedByOnDoDate
extension LocalActivityStorageTests {
    
    func test_fetchAllActivityInCoreDataOwnedByOnDoDate_whenProfileHasCoreID_thenFetchedInCoreData() throws {
        let timeout = self.sut.coreDataStorage.fetchCollectionTimeout
        let profile = self.insertedActivity.profile
        let doDate = Date().toInt64()
        
        let result = try self.sut.localActivityStorage
            .fetchAllInCoreData(ownedBy: profile, onDoDate: doDate)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result, [self.insertedActivity])
    }
    
    func test_fetchAllActivityInCoreDataOwnedByOnDoDate_whenProfileHasCoreIDAndDoDateTomorrow_thenFetchedInCoreDataButEmpty() throws {
        let timeout = self.sut.coreDataStorage.fetchCollectionTimeout
        let profile = self.insertedActivity.profile
        let doDate = Int64(1625529600) // Tuesday, July 6, 2021 12:00:00 AM
        
        let result = try self.sut.localActivityStorage
            .fetchAllInCoreData(ownedBy: profile, onDoDate: doDate)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertTrue(result.isEmpty)
        XCTAssertNotEqual(result, [self.insertedActivity])
    }
    
    func test_fetchAllActivityInCoreDataOwnedByOnDoDate_whenProfileHasNotCoreID_thenFetchedInCoreData() throws {
        let timeout = self.sut.coreDataStorage.fetchCollectionTimeout
        let profile = ProfileDomain.stubElement
        let doDate = Date().toInt64()
        
        XCTAssertThrowsError(try self.sut.localActivityStorage
                                .fetchAllInCoreData(ownedBy: profile, onDoDate: doDate)
                                .toBlocking(timeout: timeout)
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [DELETE] -> LocalActivityStorage: Failed to execute fetchAllInCoreData(ownedBy:, onDoDate:) caused by profileCoreID is not available")
        }
    }
    
}

// MARK: InsertIntoCoreData
extension LocalActivityStorageTests {
    
    func test_insertIntoCoreData_whenActivityNotAlreadyInserted_thenInsertedIntoCoreDataWithCreate() throws {
        let timeout = self.sut.coreDataStorage.insertElementTimeout
        
        let object = ActivityDomain.stubElement(coreDataStorage: self.sut.coreDataStorage).0
        
        let result = try self.sut.localActivityStorage
            .insertIntoCoreData(object)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(result.title, object.title)
    }
    
    func test_insertIntoCoreData_whenActivityAlreadyInserted_thenInsertedIntoCoreDataWithUpdate() throws {
        let timeout = self.sut.coreDataStorage.insertElementTimeout
        
        let object = self.insertedActivity!
        let updateObject = ActivityDomain(coreID: object.coreID,
                                          createdAt: object.createdAt,
                                          updatedAt: object.updatedAt,
                                          doDate: object.doDate,
                                          explanation: "Activity Updated Test",
                                          isArchived: false,
                                          isPinned: false,
                                          photoFileNames: [],
                                          title: "Activity Updated Test",
                                          profile: object.profile)
        
        let result = try self.sut.localActivityStorage
            .insertIntoCoreData(updateObject)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(result.coreID, updateObject.coreID)
        XCTAssertEqual(result.title, updateObject.title)
        XCTAssertNotEqual(result.title, object.title)
    }
    
}

// MARK: RemoveInCoreData
extension LocalActivityStorageTests {
    
    func test_removeInCoreData_whenActivityHasCoreID_thenRemovedInCoreData() throws {
        let timeout = self.sut.coreDataStorage.removeElementTimeout
        
        let result = try self.sut.localActivityStorage
            .removeInCoreData(self.insertedActivity)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertEqual(result.coreID, self.insertedActivity.coreID)
    }
    
    func test_removeInCoreData_whenActivityHasCoreID_thenThrowsCoreDataDeleteError() {
        let timeout = self.sut.coreDataStorage.removeElementTimeout
        
        let object = ActivityDomain.stubRemoveElementCoreData(coreDataStorage: self.sut.coreDataStorage).0
        
        XCTAssertThrowsError(try self.sut.localActivityStorage
                                .removeInCoreData(object)
                                .toBlocking(timeout: timeout)
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [DELETE] -> LocalActivityStorage: Failed to execute removeInCoreData() caused by coreID is not available")
        }
    }
    
}

// MARK: LocalActivityStorageSUT
public struct LocalActivityStorageSUT {
    
    public let semaphore: DispatchSemaphore
    public let disposeBag: DisposeBag
    public let coreDataStorage: CoreDataStorageSharedMock
    public let localActivityStorage: LocalActivityStorage
    
}

public extension XCTest {
    
    func makeLocalActivityStorageSUT() -> LocalActivityStorageSUT {
        let semaphore = self.makeSempahore()
        let disposeBag = self.makeDisposeBag()
        let coreDataStorage = self.makeCoreDataStorageMock()
        let localActivityStorage = DefaultLocalActivityStorage(coreDataStorage: coreDataStorage)
        return LocalActivityStorageSUT(semaphore: semaphore,
                                       disposeBag: disposeBag,
                                       coreDataStorage: coreDataStorage,
                                       localActivityStorage: localActivityStorage)
    }
    
}
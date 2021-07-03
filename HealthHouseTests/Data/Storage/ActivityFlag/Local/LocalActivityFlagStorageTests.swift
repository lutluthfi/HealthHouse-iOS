//
//  LocalActivityFlagStorageTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 16/05/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Health_House

// MARK: LocalActivityFlagStorageTests
class LocalActivityFlagStorageTests: XCTestCase {
    
    private lazy var sut = self.makeLocalActivityFlagStorageSUT()
    private var insertedActivityFlags: [ActivityFlagDomain] = []
    private var insertedActivityFlags1: ([ActivityFlagDomain], ProfileDomain)!
    private var insertedActivityFlags2: ([ActivityFlagDomain], ProfileDomain)!
    private var insertedProfile: ProfileDomain!
    
    override func setUp() {
        super.setUp()
        let coreDataStorage = self.sut.coreDataStorage
        let stubCollectionCoreData1 = ActivityFlagDomain.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        let stubCollectionCoreData2 = ActivityFlagDomain.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        self.insertedActivityFlags1 = stubCollectionCoreData1
        self.insertedActivityFlags2 = stubCollectionCoreData2
        self.insertedActivityFlags = (stubCollectionCoreData1.0 + stubCollectionCoreData2.0)
            .sorted(by: { $0.activity.createdAt < $1.activity.createdAt })
        self.insertedProfile = stubCollectionCoreData1.1
    }
    
    override func tearDown() {
        self.clearCoreDataStorage()
        super.tearDown()
    }
    
}

// MARK: FetchAllInCoreData
extension LocalActivityFlagStorageTests {
    
    func test_fetchAllInCoreData_shouldFetchedInCoreData() throws {
        let result = try self.sut.localActivityFlagStorage
            .fetchAllInCoreData()
            .toBlocking()
            .single()

        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.sorted(by: { $0.coreID.uriPathOrEmpty < $1.coreID.uriPathOrEmpty }),
                       self.insertedActivityFlags.sorted(by: { $0.coreID.uriPathOrEmpty < $1.coreID.uriPathOrEmpty }))
    }
    
}

// MARK: FetchAllInCoreDataOwnedByProfile
extension LocalActivityFlagStorageTests {
    
    func test_fetchAllInCoreDataOwnedByProfile_whenProfileHasCoreID_thenFetchedAllInCoreData() throws {
        let profile = try XCTUnwrap(self.insertedProfile)
        
        let result = try self.sut.localActivityFlagStorage
            .fetchAllInCoreData(ownedBy: profile)
            .toBlocking()
            .single()
        
        print("result: \(result.count)")
        print("insertedActivityFlags1: \(self.insertedActivityFlags1.0.count)")
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.sorted(by: { $0.coreID.uriPathOrEmpty < $1.coreID.uriPathOrEmpty }),
                       self.insertedActivityFlags1.0.sorted(by: { $0.coreID.uriPathOrEmpty < $1.coreID.uriPathOrEmpty }))
    }
    
    func test_fetchAllInCoreDataOwnedByProfile_whenProfileHasNotCoreID_thenThrowsCoreDataStorageErrorCausedByNotAvailable() throws {
        let profile = ProfileDomain.stubElement
        
        XCTAssertThrowsError(try self.sut.localActivityFlagStorage
                                .fetchAllInCoreData(ownedBy: profile)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription,
                           "CoreDataStorageError [DELETE] -> LocalActivityFlagStorage: Failed to execute fetchAllInRealm(ownedBy:) caused by profileCoreID is not available")
        }
    }
    
}

// MARK: FetchInCoreDataRelatedToActivity
extension LocalActivityFlagStorageTests {
    
    func test_fetchInCoreDataRelatedToActivity_whenActivityHasCoreID_thenFetchedInCoreData() throws {
        let activityFlag = try XCTUnwrap(self.insertedActivityFlags.first)
        
        let result = try self.sut.localActivityFlagStorage
            .fetchInCoreData(relatedTo: activityFlag.activity)
            .toBlocking()
            .single()
        
        XCTAssertEqual(result, activityFlag)
        XCTAssertEqual(result.flags, activityFlag.flags)
    }
    
    func test_fetchInCoreDataRelatedToActivity_whenActivityHasNotCoreID_thenThrowsCoreDataStorageErrorCausedByNotFound() throws {
        let coreDataStorage = self.sut.coreDataStorage
        let activityFlag = ActivityFlagDomain.stubElementWhenActivityHasCoreID(coreDataStorage: coreDataStorage)
        let activity = activityFlag.activity
        
        XCTAssertThrowsError(try self.sut.localActivityFlagStorage
                                .fetchInCoreData(relatedTo: activity)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription,
                           "CoreDataStorageError [DELETE] -> LocalActivityFlagStorage: Failed to execute fetchAllInRealm(activity:) caused by activityCoreID is not found")
        }
    }
    
    func test_fetchInCoreDataRelatedToActivity_whenActivityHasNotCoreID_thenThrowsCoreDataStorageErrorCausedByNotAvailable() throws {
        let coreDataStorage = self.sut.coreDataStorage
        let activityFlag = ActivityFlagDomain.stubElementWhenActivityHasNotCoreID(coreDataStorage: coreDataStorage)
        let activity = activityFlag.activity
        
        XCTAssertThrowsError(try self.sut.localActivityFlagStorage
                                .fetchInCoreData(relatedTo: activity)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription,
                           "CoreDataStorageError [DELETE] -> LocalActivityFlagStorage: Failed to execute fetchAllInRealm(activity:) caused by activityCoreID is not available")
        }
    }
    
}

// MARK: InsertUpdateIntoCoreData
extension LocalActivityFlagStorageTests {
    
    func test_insertUpdateIntoCoreData_whenActivityHasCoreID_thenInsertedIntoCoreData() throws {
        let coreDataStorage = self.sut.coreDataStorage
        let activityFlag = ActivityFlagDomain.stubElementWhenActivityHasCoreID(coreDataStorage: coreDataStorage)
        
        let result = try self.sut.localActivityFlagStorage
            .insertUpdateIntoCoreData(activityFlag)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(result.activity.coreID, activityFlag.activity.coreID)
        XCTAssertEqual(result.flags, activityFlag.flags)
    }
    
    func test_insertUpdateIntoCoreData_whenActivityHasNotCoreID_thenThrowsErrorCausedByNotAvailable() throws {
        let coreDataStorage = self.sut.coreDataStorage
        let activityFlag = ActivityFlagDomain.stubElementWhenActivityHasNotCoreID(coreDataStorage: coreDataStorage)
        
        XCTAssertThrowsError(try self.sut.localActivityFlagStorage
                                .insertUpdateIntoCoreData(activityFlag)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription,
                           "CoreDataStorageError [DELETE] -> LocalActivityFlagStorage: Failed to execute insertUpdateIntoCoreData(_:) caused by activityCoreID is not available")
        }
    }
    
}

// MARK: RemoveInCoreDataRelatedTo
extension LocalActivityFlagStorageTests {
    
    func test_removeInCoreDataRelatedToActivity_whenActivityHasCoreID_thenRemovedInCoreData() throws {
        let activityFlag = try XCTUnwrap(self.insertedActivityFlags1.0.first)
        let activity = activityFlag.activity
        
        let result = try self.sut.localActivityFlagStorage
            .removeInCoreData(relatedTo: activity)
            .toBlocking()
            .single()
        
        XCTAssertEqual(result, activityFlag)
    }
    
    func test_removeInCoreDataRelatedToActivity_whenActivityHasNotCoreID_thenThrowsErrorCausedByNotAvailable() throws {
        let coreDataStorage = self.sut.coreDataStorage
        let activityFlag = ActivityFlagDomain.stubElementWhenActivityHasNotCoreID(coreDataStorage: coreDataStorage)
        let activity = activityFlag.activity
        
        XCTAssertThrowsError(try self.sut.localActivityFlagStorage
                                .removeInCoreData(relatedTo: activity)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription,
                           "CoreDataStorageError [DELETE] -> LocalActivityFlagStorage: Failed to execute removeInRealm(activity:) caused by activityCoreID is not available")
        }
    }
    
    func test_removeInCoreDataRelatedToActivity_whenActivityHasNotCoreID_thenThrowsErrorCausedByNotFound() throws {
        let coreDataStorage = self.sut.coreDataStorage
        let activityFlag = ActivityFlagDomain.stubElementWhenActivityHasCoreID(coreDataStorage: coreDataStorage)
        let activity = activityFlag.activity
        
        XCTAssertThrowsError(try self.sut.localActivityFlagStorage
                                .removeInCoreData(relatedTo: activity)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription,
                           "CoreDataStorageError [DELETE] -> LocalActivityFlagStorage: Failed to execute removeInRealm(activity:) caused by activityCoreID is not found")
        }
    }
    
}

struct LocalActivityFlagStorageSUT {
    
    let disposeBag: DisposeBag
    let coreDataStorage: CoreDataStorageSharedMock
    let localActivityFlagStorage: LocalActivityFlagStorage
    
}

extension XCTest {
    
    func makeLocalActivityFlagStorageSUT(coreDataStorage: CoreDataStorageSharedMock = CoreDataStorageMock()) -> LocalActivityFlagStorageSUT {
        let disposeBag = self.makeDisposeBag()
        let localActivityFlagStorage = DefaultLocalActivityFlagStorage(coreDataStorage: coreDataStorage)
        return LocalActivityFlagStorageSUT(disposeBag: disposeBag,
                                           coreDataStorage: coreDataStorage,
                                           localActivityFlagStorage: localActivityFlagStorage)
    }
    
}

//
//  ActivityRepositoryTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import DEV_Health_Diary

// MARK: ActivityRepositoryTests
class ActivityRepositoryTests: XCTestCase {
    
    private lazy var sut = self.makeActivityRepositorySUT()
    private var insertedActivity: (ActivityDomain, ProfileDomain)!
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        self.removeStub()
        super.tearDown()
    }
    
    private func makeStub() {
        let coreDataStorage = self.sut.coreDataStorage
        self.insertedActivity = ActivityDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
    }
    
    private func removeStub() {
        self.removeCoreDataStorage()
    }
    
}

// MARK: FetchAllActivity Function
extension ActivityRepositoryTests {
    
    func test_fetchAllActivity_whenStoragePointCoreData_thenFetchedInCoreData() throws {
        let timeout = self.sut.coreDataStorage.fetchCollectionTimeout
        
        let result = try self.sut.activityRepository
            .fetchAllActivity(in: .coreData)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result, [self.insertedActivity.0])
    }
    
    func test_fetchAllActivity_whenStoragePointUserDefault_thenObservePlainError() {
        let timeout = self.sut.coreDataStorage.removeElementTimeout
        
        XCTAssertThrowsError(try self.sut.activityRepository
                                .fetchAllActivity(in: .userDefault)
                                .toBlocking(timeout: timeout)
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "ActivityRepository -> fetchAllActivity() is not available for UserDefaults")
        }
    }
    
}

// MARK: FetchAllActivityOwnedBy Function
extension ActivityRepositoryTests {
    
    func test_fetchAllActivityOwnedBy_whenProfileHasCoreIDAndStoragePointCoreData_thenFetchedInCoreData() throws {
        let timeout = self.sut.coreDataStorage.fetchCollectionTimeout
        let profile = self.insertedActivity.1
        
        let result = try self.sut.activityRepository
            .fetchAllActivity(ownedBy: profile, in: .coreData)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result, [self.insertedActivity.0])
    }
    
    func test_fetchAllActivityOwnedBy_whenProfileHasCoreIDAndStorageRemotes_thenThrowsError() {
        let timeout = self.sut.coreDataStorage.removeElementTimeout
        let profile = self.insertedActivity.1
        
        XCTAssertThrowsError(try self.sut.activityRepository
                                .fetchAllActivity(ownedBy: profile, in: .remote)
                                .toBlocking(timeout: timeout)
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "ActivityRepository -> fetchAllActivity(ownedBy:) is not available for Remote")
        }
    }
    
    func test_fetchAllActivityOwnedBy_whenProfileHasCoreIDAndStorageUserDefaults_thenThrowsError() {
        let timeout = self.sut.coreDataStorage.removeElementTimeout
        let profile = self.insertedActivity.1
        
        XCTAssertThrowsError(try self.sut.activityRepository
                                .fetchAllActivity(ownedBy: profile, in: .userDefault)
                                .toBlocking(timeout: timeout)
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "ActivityRepository -> fetchAllActivity(ownedBy:) is not available for UserDefaults")
        }
    }
    
    func test_fetchAllActivityOwnedBy_whenProfileHasNotCoreIDAndStoragePointCoreData_thenThrowsCoreDataStorageError() throws {
        let timeout = self.sut.coreDataStorage.fetchCollectionTimeout
        let profile = ProfileDomain.stubElement
        
        XCTAssertThrowsError(try self.sut.activityRepository
                                .fetchAllActivity(ownedBy: profile, in: .coreData)
                                .toBlocking(timeout: timeout)
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [DELETE] -> LocalActivityStorage: Failed to execute fetchAllInCoreData() caused by profileCoreID is not available")
        }
    }
    
}

// MARK: InsertActivity Function
extension ActivityRepositoryTests {
    
    func test_insertActivity_whenStoragePointCoreData_thenInsertedIntoCoreData() throws {
        let timeout = self.sut.coreDataStorage.insertElementTimeout
        
        let object = ActivityDomain.stubElement(coreDataStorage: self.sut.coreDataStorage).0
        let storagePoint = StoragePoint.coreData
        
        let result = try self.sut.activityRepository
            .insertActivity(object, into: storagePoint)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(result.title, object.title)
    }
    
    func test_insertActivity_whenStoragePointUserDefaults_thenObserverPlainError() {
        let timeout = self.sut.coreDataStorage.removeElementTimeout
        let object = ActivityDomain.stubElement(coreDataStorage: self.sut.coreDataStorage).0
        
        XCTAssertThrowsError(try self.sut.activityRepository
                                .insertActivity(object, into: .userDefault)
                                .toBlocking(timeout: timeout)
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "ActivityRepository -> insertActivity() is not available for UserDefaults")
        }
    }
    
}

// MARK: ActivityRepositorySUT
public struct ActivityRepositorySUT {
    
    public let disposeBag: DisposeBag
    public let coreDataStorage: CoreDataStorageSharedMock
    public let localActivityStorage: LocalActivityStorage
    public let activityRepository: ActivityRepository
    
}

public extension XCTest {
    
    func makeActivityRepositorySUT() -> ActivityRepositorySUT {
        let disposeBag = self.makeDisposeBag()
        let coreDataStorage = self.makeCoreDataStorageMock()
        let localActivityStorage = DefaultLocalActivityStorage(coreDataStorage: coreDataStorage)
        let activityRepository = DefaultActivityRepository(localActivityStorage: localActivityStorage)
        return ActivityRepositorySUT(disposeBag: disposeBag,
                                     coreDataStorage: coreDataStorage,
                                     localActivityStorage: localActivityStorage,
                                     activityRepository: activityRepository)
    }
    
}

//
//  FlagRepositoryTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Health_House

class FlagRepositoryTests: XCTestCase {
    
    private lazy var sut = self.makeFlagRepositorySUT()
    private var insertedActivityFlag: ActivityFlagDomain!

    override func setUp() {
        super.setUp()
        let coreDataStorage = self.sut.coreDataStorage
        self.insertedActivityFlag = ActivityFlagDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
    }
    
    override func tearDown() {
        self.clearCoreDataStorage()
        super.tearDown()
    }

}

// MARK: FetchAllFlag
extension FlagRepositoryTests {
    
    func test_fetchAllFlag_whenStoragePointCoreData_thenFetchedAllFlagInCoreData() throws {
        let result = try self.sut.flagRepository
            .fetchAllFlag(in: .coreData)
            .toBlocking()
            .single()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.sorted(by: { $0.coreID.uriPathOrEmpty < $1.coreID.uriPathOrEmpty }),
                       self.insertedActivityFlag.flags.sorted(by: { $0.coreID.uriPathOrEmpty < $1.coreID.uriPathOrEmpty }))
    }
    
    func test_fetchAllFlag_whenStoragePointRemote_thenThrowsErrorStoragePointNotSupported() throws {
        XCTAssertThrowsError(try self.sut.flagRepository
                                .fetchAllFlag(in: .remote)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "FlagRepository -> fetchAllFlag() is not available for Remote")
        }
    }
    
    func test_fetchAllFlag_whenStoragePointUserDefaults_thenThrowsErrorStoragePointNotSupported() throws {
        XCTAssertThrowsError(try self.sut.flagRepository
                                .fetchAllFlag(in: .userDefaults)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "FlagRepository -> fetchAllFlag() is not available for UserDefaults")
        }
    }
    
}

// MARK: FetchAllFlagOwnedByProfile
extension FlagRepositoryTests {
    
    func test_fetchAllFlagOwnedByProfile_whenStoragePointCoreData_thenFetchAllFlagInCoreData() throws {
        let profile = try XCTUnwrap(self.insertedActivityFlag.activity.profile)
        
        let result = try self.sut.flagRepository
            .fetchAllFlag(ownedBy: profile, in: .coreData)
            .toBlocking()
            .single()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.sorted(by: { $0.coreID.uriPathOrEmpty < $1.coreID.uriPathOrEmpty }),
                       self.insertedActivityFlag.flags.sorted(by: { $0.coreID.uriPathOrEmpty < $1.coreID.uriPathOrEmpty }))
        
    }

    func test_fetchAllFlagOwnedByProfile_whenStoragePointRemote_thenThrowsErrorStoragePointNotSupported() throws {
        let profile = try XCTUnwrap(self.insertedActivityFlag.activity.profile)
        
        XCTAssertThrowsError(try self.sut.flagRepository
                                .fetchAllFlag(ownedBy: profile, in: .remote)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "FlagRepository -> fetchAllFlag() is not available for Remote")
        }
    }
    
    func test_fetchAllFlagOwnedByProfile_whenStoragePointUserDefaults_thenThrowsErrorStoragePointNotSupported() throws {
        let profile = try XCTUnwrap(self.insertedActivityFlag.activity.profile)
        
        XCTAssertThrowsError(try self.sut.flagRepository
                                .fetchAllFlag(ownedBy: profile, in: .userDefaults)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "FlagRepository -> fetchAllFlag() is not available for UserDefaults")
        }
    }
    
}

// MARK: InsertFlag
extension FlagRepositoryTests {
    
    func test_insertFlag_whenStoragePointCoreData_thenInsertedInCoreData() throws {
        let flag = FlagDomain.stubElement
        
        let result = try self.sut.flagRepository
            .insertFlag(flag, in: .coreData)
            .toBlocking()
            .single()
        
        XCTAssertNil(flag.coreID)
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(flag.name, result.name)
    }
    
    func test_insertFlag_whenStoragePointRemote_thenThrowsErrorStoragePointNotSupport() throws {
        let flag = FlagDomain.stubElement
        
        XCTAssertThrowsError(try self.sut.flagRepository
                                .insertFlag(flag, in: .remote)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "FlagRepository -> insertFlag() is not available for Remote")
        }
    }
    
    func test_insertFlag_whenStoragePointUserDefaults_thenThrowsErrorStoragePointNotSupport() throws {
        let flag = FlagDomain.stubElement
        
        XCTAssertThrowsError(try self.sut.flagRepository
                                .insertFlag(flag, in: .userDefaults)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "FlagRepository -> insertFlag() is not available for UserDefaults")
        }
    }
    
}

struct FlagRepositorySUT {
    let coreDataStorage: CoreDataStorageSharedMock
    let flagRepository: FlagRepository
}

extension XCTest {
    
    func makeFlagRepositorySUT(coreDataStorage: CoreDataStorageSharedMock = CoreDataStorageMock()) -> FlagRepositorySUT {
        let localActivityFlagStorageSUT = self.makeLocalActivityFlagStorageSUT(coreDataStorage: coreDataStorage)
        let localFlagStorageSUT = self.makeLocalFlagStorageSUT(coreDataStorage: coreDataStorage)
        let localActivityFlagStorage = localActivityFlagStorageSUT.localActivityFlagStorage
        let localFlagStorage = localFlagStorageSUT.localFlagStorage
        let flagRepository = DefaultFlagRepository(localActivityFlagStorage: localActivityFlagStorage,
                                                   localFlagStorage: localFlagStorage)
        return FlagRepositorySUT(coreDataStorage: coreDataStorage, flagRepository: flagRepository)
    }
    
}

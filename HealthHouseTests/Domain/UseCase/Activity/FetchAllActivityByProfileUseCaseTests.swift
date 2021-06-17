//
//  FetchAllActivityByProfileUseCaseTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 21/04/21.
//

import RxSwift
import RxTest
import XCTest
@testable import Health_House

class FetchAllActivityByProfileUseCaseTests: XCTestCase {

    private lazy var sut = self.makeFetchAllActivityByProfileUseCaseSUT()
    private var insertedActivities: ([ActivityDomain], ProfileDomain?) = ([], nil)
    
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
        self.insertedActivities = ActivityDomain.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        ActivityDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
    }
    
    private func removeStub() {
        self.clearCoreDataStorage()
    }

}

// MARK: Tests Function
extension FetchAllActivityByProfileUseCaseTests {
    
    func test_execute_whenProfileHasCoreID_thenFetchedInCoreData() throws {
        let profile = try XCTUnwrap(self.insertedActivities.1)
        let request = FetchAllActivityByProfileUseCaseRequest(profile: profile)
        
        let result = try self.sut.useCase
            .execute(request)
            .toBlocking()
            .single()
            .activities
            .sorted(by: { $0.title < $1.title })
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result, self.insertedActivities.0)
    }
    
    func test_execute_whenProfileHasNotCoreID_thenThrowsCoreDataStorageError() throws {
        let profile = ProfileDomain.stubElement
        let request = FetchAllActivityByProfileUseCaseRequest(profile: profile)
        
        XCTAssertThrowsError(try self.sut.useCase
                                .execute(request)
                                .toBlocking()
                                .single()
                                .activities
                                .sorted(by: { $0.title < $1.title })) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [DELETE] -> LocalActivityStorage: Failed to execute fetchAllInRealm(ownedBy:) caused by profileCoreID is not available")
        }
    }
    
}

struct FetchAllActivityByProfileUseCaseSUT {
    
    let coreDataStorage: CoreDataStorageSharedMock
    let useCase: FetchAllActivityByProfileUseCase
    
}

extension XCTest {
    
    func makeFetchAllActivityByProfileUseCaseSUT() -> FetchAllActivityByProfileUseCaseSUT {
        let coreDataStorage = self.makeCoreDataStorageMock()
        let localActivityStorage = DefaultLocalActivityStorage(coreDataStorage: coreDataStorage)
        let activityRepository = DefaultActivityRepository(localActivityStorage: localActivityStorage)
        let useCase = DefaultFetchAllActivityByProfileUseCase(activityRepository: activityRepository)
        return FetchAllActivityByProfileUseCaseSUT(coreDataStorage: coreDataStorage, useCase: useCase)
    }
    
}

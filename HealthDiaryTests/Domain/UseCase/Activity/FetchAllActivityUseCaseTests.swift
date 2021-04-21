//
//  FetchAllActivityUseCaseTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 21/04/21.
//

import RxSwift
import RxTest
import XCTest
@testable import DEV_Health_Diary

class FetchAllActivityUseCaseTests: XCTestCase {

    private lazy var sut = self.makeFetchActivityUseCaseSUT()
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
        self.removeCoreDataStorage()
    }

}

// MARK: Tests Function
extension FetchAllActivityUseCaseTests {
    
    func test_execute_whenProfileHasCoreID_thenFetchedInCoreData() throws {
        let profile = try XCTUnwrap(self.insertedActivities.1)
        let request = FetchAllActivityUseCaseRequest(profile: profile)
        
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
        let request = FetchAllActivityUseCaseRequest(profile: profile)
        
        XCTAssertThrowsError(try self.sut.useCase
                                .execute(request)
                                .toBlocking()
                                .single()
                                .activities
                                .sorted(by: { $0.title < $1.title })) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [DELETE] -> LocalActivityStorage: Failed to execute fetchAllInCoreData() caused by profileCoreID is not available")
        }
    }
    
}

struct FetchActivityUseCaseSUT {
    
    let coreDataStorage: CoreDataStorageSharedMock
    let useCase: FetchAllActivityUseCase
    
}

extension XCTest {
    
    func makeFetchActivityUseCaseSUT() -> FetchActivityUseCaseSUT {
        let coreDataStorage = self.makeCoreDataStorageMock()
        let localActivityStorage = DefaultLocalActivityStorage(coreDataStorage: coreDataStorage)
        let activityRepository = DefaultActivityRepository(localActivityStorage: localActivityStorage)
        let useCase = DefaultFetchAllActivityUseCase(activityRepository: activityRepository)
        return FetchActivityUseCaseSUT(coreDataStorage: coreDataStorage, useCase: useCase)
    }
    
}

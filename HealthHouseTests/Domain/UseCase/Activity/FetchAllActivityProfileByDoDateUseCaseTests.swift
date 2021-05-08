//
//  FetchAllActivityProfileByDoDateUseCaseTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 08/05/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Health_House

class FetchAllActivityProfileByDoDateUseCaseTests: XCTestCase {

    private lazy var sut = self.makeFetchAllActivityProfileByDoDateUseCaseSUT()
    private var insertedActivities: ([ActivityDomain], ProfileDomain)!
    
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
    }
    
    private func removeStub() {
        self.removeCoreDataStorage()
    }
    
}

extension FetchAllActivityProfileByDoDateUseCaseTests {
    
    func test_execute() throws {
        let doDate = Date().toInt64()
        let profile = self.insertedActivities.1
        
        let request = FetchAllActivityProfileByDoDateUseCaseRequest(doDate: doDate, profile: profile)
        let result = try self.sut.useCase
            .execute(request)
            .toBlocking()
            .single()
            .activities
            .sorted(by: { $0.title < $1.title })
        
        XCTAssertEqual(result, self.insertedActivities.0)
    }
    
}

struct FetchAllActivityProfileByDoDateUseCaseSUT {
    let coreDataStorage: CoreDataStorageSharedMock
    let useCase: FetchAllActivityProfileByDoDateUseCase
}

extension XCTest {
    
    func makeFetchAllActivityProfileByDoDateUseCaseSUT() -> FetchAllActivityProfileByDoDateUseCaseSUT {
        let repositorySUT = self.makeActivityRepositorySUT()
        let coreDataStorage = repositorySUT.coreDataStorage
        let activityRepository = repositorySUT.activityRepository
        let useCase = DefaultFetchAllActivityProfileByDoDateUseCase(activityRepository: activityRepository)
        return FetchAllActivityProfileByDoDateUseCaseSUT(coreDataStorage: coreDataStorage, useCase: useCase)
    }
    
}

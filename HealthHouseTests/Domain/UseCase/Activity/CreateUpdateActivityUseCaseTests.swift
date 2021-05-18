//
//  CreateUpdateActivityUseCaseTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Health_House

class CreateUpdateActivityUseCaseTests: XCTestCase {
    
    private lazy var sut = self.makeCreateUpdateActivityUseCaseSUT()
    private var insertedActivities: (ActivityDomain, ProfileDomain)!
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        super.tearDown()
        self.removeStub()
    }
    
    private func makeStub() {
        let coreDataStorage = self.sut.coreDataStorage
        self.insertedActivities = ActivityDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
    }
    
    private func removeStub() {
        self.clearCoreDataStorage()
    }
    
}

extension CreateUpdateActivityUseCaseTests {
    
    func test_execute_whenActivityAlreadyNotInCoreDataProfileAlreadyNotInCoreData_thenThrowsError() throws {
        let doDate = Date().toInt64()
        let explanation = "Explanation"
        let profile = ProfileDomain.stubElement
        let title = "Title"
        let request = CreateUpdateActivityUseCaseRequest(coreID: nil,
                                                         doDate: doDate,
                                                         explanation: explanation,
                                                         photoFileURLs: [],
                                                         profile: profile,
                                                         title: title)
        
        XCTAssertThrowsError(try self.sut.useCase
                                .execute(request)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription, "CoreDataStorageError [SAVE] -> LocalActivityStorage: Failed to execute insertIntoCoreData() caused by Profile coreID is not available")
        }
    }
    
    func test_execute_whenActivityAlreadyNotInCoreDataProfileAlreadyInCoreData_thenCreatedActivityInCoreData() throws {
        let doDate = Date().toInt64()
        let explanation = "Explanation"
        let profile = ProfileDomain.stubElementCoreData(coreDataStorage: self.sut.coreDataStorage)
        let title = "Title"
        let request = CreateUpdateActivityUseCaseRequest(coreID: nil,
                                                         doDate: doDate,
                                                         explanation: explanation,
                                                         photoFileURLs: [],
                                                         profile: profile,
                                                         title: title)
        
        let result = try self.sut.useCase
            .execute(request)
            .toBlocking()
            .single()
            .activity
        
        XCTAssertNotNil(result.coreID)
    }
    
    func test_execute_whenActivityAlreadyInCoreData_thenUpdatedActivityInCoreData() throws {
        let coreID = self.insertedActivities.0.coreID
        let doDate = self.insertedActivities.0.doDate
        let explanation = "Explanation Updated"
        let profile = self.insertedActivities.1
        let title = "Title Updated"
        let request = CreateUpdateActivityUseCaseRequest(coreID: coreID,
                                                         doDate: doDate,
                                                         explanation: explanation,
                                                         photoFileURLs: [],
                                                         profile: profile,
                                                         title: title)
        
        let result = try self.sut.useCase
            .execute(request)
            .toBlocking()
            .single()
            .activity
        
        XCTAssertNotNil(result.coreID)
        XCTAssertNotEqual(self.insertedActivities.0.title, title)
        XCTAssertNotEqual(self.insertedActivities.0.explanation, explanation)
        XCTAssertEqual(self.insertedActivities.1, profile)
    }
    
}

struct CreateUpdateActivityUseCaseSUT {
    
    let coreDataStorage: CoreDataStorageSharedMock
    let repository: ActivityRepository
    let useCase: CreateUpdateActivityUseCase
    
}

extension XCTest {
    
    func makeCreateUpdateActivityUseCaseSUT() -> CreateUpdateActivityUseCaseSUT {
        let activityRepositorySUT = self.makeActivityRepositorySUT()
        let coreDataStorage = activityRepositorySUT.coreDataStorage
        let activityRepository = activityRepositorySUT.activityRepository
        let useCase = DefaultCreateUpdateActivityUseCase(activityRepository: activityRepository)
        return CreateUpdateActivityUseCaseSUT(coreDataStorage: coreDataStorage,
                                              repository: activityRepository,
                                              useCase: useCase)
    }
    
}

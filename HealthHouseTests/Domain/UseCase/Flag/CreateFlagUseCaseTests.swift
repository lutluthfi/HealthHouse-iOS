//
//  CreateFlagUseCaseTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Health_House

class CreateFlagUseCaseTests: XCTestCase {
    
    private lazy var sut = self.makeCreateFlagUseCaseSUT()
    private var insertedFlag: FlagDomain!
    
    override func setUp() {
        super.setUp()
        let coreDataStorage = self.sut.coreDataStorage
        self.insertedFlag = FlagDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
    }
    
    override func tearDown() {
        self.clearCoreDataStorage()
        super.tearDown()
    }
    
}

extension CreateFlagUseCaseTests {
    
    func test_execute_shouldCreated() throws {
        let request = CreateFlagUseCaseRequest(coreID: nil, hexcolor: UIColor.red.hexString(), name: "New Flag")
        
        let result = try self.sut.useCase
            .execute(request)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.flag.coreID)
        XCTAssertEqual("New Flag", result.flag.name)
    }
    
    func test_execute_whenFlagHasCoreID_thenThrowsError() throws {
        let flag = try XCTUnwrap(self.insertedFlag)
        let request = CreateFlagUseCaseRequest(coreID: flag.coreID, hexcolor: flag.hexcolor, name: "Update Flag")
        
        XCTAssertThrowsError(try self.sut.useCase
                                .execute(request)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is CoreDataStorageError)
            XCTAssertEqual(error.localizedDescription,
                           "CoreDataStorageError [SAVE] -> LocalFlagStorage: Failed to execute insertIntoCoreData() caused by flagCoreID is already exist")
        }
    }
    
}

struct CreateFlagUseCaseSUT {
    let coreDataStorage: CoreDataStorageSharedMock
    let useCase: CreateFlagUseCase
}

extension XCTest {
    
    func makeCreateFlagUseCaseSUT(coreDataStorage: CoreDataStorageSharedMock = CoreDataStorageMock()) -> CreateFlagUseCaseSUT {
        let flagRepositorySUT = self.makeFlagRepositorySUT(coreDataStorage: coreDataStorage)
        let flagRepository = flagRepositorySUT.flagRepository
        let useCase = DefaultCreateFlagUseCase(flagRepository: flagRepository)
        return CreateFlagUseCaseSUT(coreDataStorage: coreDataStorage, useCase: useCase)
    }
    
}

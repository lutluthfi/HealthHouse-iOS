//
//  CreateUpdateFlagUseCaseTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Health_House

class CreateUpdateFlagUseCaseTests: XCTestCase {
    
    private lazy var sut = self.makeCreateUpdateFlagUseCaseSUT()
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

extension CreateUpdateFlagUseCaseTests {
    
    func test_execute_whenFlagHasNotCoreID_thenCreated() throws {
        let request = CreateUpdateFlagUseCaseRequest(coreID: nil, color: .red, name: "New Flag")
        
        let result = try self.sut.useCase
            .execute(request)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.flag.coreID)
        XCTAssertEqual("New Flag", result.flag.name)
    }
    
    func test_execute_whenFlagHasCoreID_thenUpdated() throws {
        let flag = try XCTUnwrap(self.insertedFlag)
        let request = CreateUpdateFlagUseCaseRequest(coreID: flag.coreID, color: UIColor(hex: flag.hexcolor), name: "Update Flag")
        
        let result = try self.sut.useCase
            .execute(request)
            .toBlocking()
            .single()
        
        XCTAssertEqual(flag.coreID, result.flag.coreID)
        XCTAssertEqual("Update Flag", result.flag.name)
    }
    
}

struct CreateUpdateFlagUseCaseSUT {
    let coreDataStorage: CoreDataStorageSharedMock
    let useCase: CreateUpdateFlagUseCase
}

extension XCTest {
    
    func makeCreateUpdateFlagUseCaseSUT(coreDataStorage: CoreDataStorageSharedMock = CoreDataStorageMock()) -> CreateUpdateFlagUseCaseSUT {
        let flagRepositorySUT = self.makeFlagRepositorySUT(coreDataStorage: coreDataStorage)
        let flagRepository = flagRepositorySUT.flagRepository
        let useCase = DefaultCreateUpdateFlagUseCase(flagRepository: flagRepository)
        return CreateUpdateFlagUseCaseSUT(coreDataStorage: coreDataStorage, useCase: useCase)
    }
    
}

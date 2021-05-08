//
//  FetchCountryDialingCodeUseCaseTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 11/04/21.
//

import XCTest
@testable import Health_House

class FetchCountryDialingCodeUseCaseTests: XCTestCase {
    
    private lazy var sut = self.makeFetchCountryDialingCodeUseCaseSUT()
    
    func test() throws {
        let request = FetchCountryDialingCodeUseCaseRequest()
        let result = try self.sut.useCase
            .execute(request)
            .toBlocking(timeout: self.sut.timeout)
            .single()
        
        XCTAssertTrue(!result.countryDialingCodes.isEmpty)
        XCTAssertEqual(result.countryDialingCodes.first?.name, "Afghanistan")
        XCTAssertEqual(result.countryDialingCodes.last?.name, "Zimbabwe")
    }
    
}

struct FetchCountryDialingCodeUseCaseSUT {
    
    let timeout: TimeInterval
    let useCase: FetchCountryDialingCodeUseCase
    
}

extension XCTest {
    
    func makeFetchCountryDialingCodeUseCaseSUT() -> FetchCountryDialingCodeUseCaseSUT {
        let timeout = TimeInterval(5)
        let remoteStorage = DefaultRemoteCountryDialingCodeStorage()
        let repository = DefaultCountryDialingCodeRepository(remoteCountryDialingCodeStorage: remoteStorage)
        let useCase = DefaultFetchCountryDialingCodeUseCase(countryDialingCodeRepository: repository)
        return FetchCountryDialingCodeUseCaseSUT(timeout: timeout, useCase: useCase)
    }
    
}

//
//  CountryDialingCodeRepositoryTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Health_House

class CountryDialingCodeRepositoryTests: XCTestCase {

    private lazy var sut = self.makeCountryDialingCodeRepositorySUT()
    
    func test_fetchAllCountryDialingCode_whenStoragePointCoreData_thenThrowsPlainError() throws {
        let storagePoint = StoragePoint.coreData
        
        XCTAssertThrowsError(try self.sut.countryDialingCodeRepository
                                .fetchAllCountryDialingCode(in: storagePoint)
                                .toBlocking(timeout: TimeInterval(3))
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "CountryDialingCodeRepository -> fetchAllCountryDialingCode() is not available for CoreData")
        }
    }
    
    func test_fetchAllCountryDialingCode_whenStoragePointRemote_thenFetchedAllCountryDialingCode() throws {
        let storagePoint = StoragePoint.remote
        
        let result = try self.sut.countryDialingCodeRepository
            .fetchAllCountryDialingCode(in: storagePoint)
            .toBlocking(timeout: TimeInterval(5))
            .single()
        
        XCTAssertTrue(!result.isEmpty)
        XCTAssertEqual(result.first?.name, "Afghanistan")
        XCTAssertEqual(result.last?.name, "Zimbabwe")
    }
    
    func test_fetchAllCountryDialingCode_whenStoragePointUserDefaults_thenThrowsPlainError() throws {
        let storagePoint = StoragePoint.userDefaults
        
        XCTAssertThrowsError(try self.sut.countryDialingCodeRepository
                                .fetchAllCountryDialingCode(in: storagePoint)
                                .toBlocking(timeout: TimeInterval(5))
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "CountryDialingCodeRepository -> fetchAllCountryDialingCode() is not available for UserDefaults")
        }
    }
    
}

// MARK: CountryDialingCodeRepositorySUT
public struct CountryDialingCodeRepositorySUT {
    
    public let semaphore: DispatchSemaphore
    public let disposeBag: DisposeBag
    public let remoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage
    public let countryDialingCodeRepository: CountryDialingCodeRepository
    
}

public extension XCTest {
    
    func makeCountryDialingCodeRepositorySUT() -> CountryDialingCodeRepositorySUT {
        let semaphore = self.makeSempahore()
        let disposeBag = self.makeDisposeBag()
        let remoteCountryDialingCodeStorage = DefaultRemoteCountryDialingCodeStorage()
        let countryDialingCodeRepository = DefaultCountryDialingCodeRepository(remoteCountryDialingCodeStorage: remoteCountryDialingCodeStorage)
        return CountryDialingCodeRepositorySUT(semaphore: semaphore,
                                               disposeBag: disposeBag,
                                               remoteCountryDialingCodeStorage: remoteCountryDialingCodeStorage,
                                               countryDialingCodeRepository: countryDialingCodeRepository)
    }
    
}

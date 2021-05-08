//
//  RemoteCountryDialingCodeStorageTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Health_House

class RemoteCountryDialingCodeStorageTests: XCTestCase {

    private lazy var sut: RemoteCountryDialingCodeStorageSUT = self.makeRemoteCountryDialingCodeStorageSUT()
    
    func test_fetchAllInRemote_shouldFetchedAllCountryDialingCode() throws {
       let result = try self.sut.remoteCountryDialingCodeStorage
            .fetchAllInRemote()
            .toBlocking(timeout: TimeInterval(3))
            .single()
        
        XCTAssertTrue(!result.isEmpty)
        XCTAssertEqual(result.first?.name, "Afghanistan")
        XCTAssertEqual(result.last?.name, "Zimbabwe")
    }

}

// MARK: RemoteCountryDialingCodeStorageSUT
public struct RemoteCountryDialingCodeStorageSUT {
    
    public let semaphore: DispatchSemaphore
    public let disposeBag: DisposeBag
    public let remoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage
    
}

public extension XCTest {
    
    func makeRemoteCountryDialingCodeStorageSUT() -> RemoteCountryDialingCodeStorageSUT {
        let semaphore = self.makeSempahore()
        let disposeBag = self.makeDisposeBag()
        let remoteCountryDialingCodeStorage = DefaultRemoteCountryDialingCodeStorage()
        return RemoteCountryDialingCodeStorageSUT(semaphore: semaphore,
                                                  disposeBag: disposeBag,
                                                  remoteCountryDialingCodeStorage: remoteCountryDialingCodeStorage)
    }
    
}

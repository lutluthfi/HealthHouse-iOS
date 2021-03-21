//
//  XCTest+SUT.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 21/03/21.
//

import RxSwift
import RxTest
import XCTest
@testable import DEV_Health_Diary

extension XCTest {
    
    func makeDisposeBag() -> DisposeBag {
        return DisposeBag()
    }
    func makeSempahore() -> DispatchSemaphore {
        return DispatchSemaphore(value: 0)
    }
    
    // MARK: - CoreData
    func makeCoreDataStorageMock() -> CoreDataStorageSharedMock {
        return CoreDataStorageMock()
    }
    
    // MARK: - Storage
    typealias LocalActivityStorageSUT = (coreDataStorageMock: CoreDataStorageSharedMock,
                                         localActivityStorage: LocalActivityStorage)
    func makeLocalActivityStorageSUT() -> LocalActivityStorageSUT {
        let coreDataStorageMock = self.makeCoreDataStorageMock()
        let localActivityStorage = DefaultLocalActivityStorage(coreDataStorage: coreDataStorageMock)
        return (coreDataStorageMock, localActivityStorage)
    }
    
}

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

public extension XCTest {
    
    func makeDisposeBag() -> DisposeBag {
        return DisposeBag()
    }
    func makeSempahore() -> DispatchSemaphore {
        return DispatchSemaphore(value: 0)
    }
    func makeCoreDataStorageMock() -> CoreDataStorageSharedMock {
        return CoreDataStorageMock()
    }
    
}

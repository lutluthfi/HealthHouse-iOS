//
//  StoragePointTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 30/03/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import DEV_Health_Diary

class StoragePointTests: XCTestCase {

    func test_makeCoreDataStorageNotSupported_shouldOnError() {
        let `class` = StoragePointTests.self
        let function = "insert()"
        let testExpectationDescription = "\(String(describing: `class`)) -> \(function) is not available for CoreData"
        let testExpectation = expectation(description: testExpectationDescription)
        
        StoragePoint
            .makeCoreDataStorageNotSupported(class: `class`, function: function, object: String.self)
            .subscribe(onError: { error in
                XCTAssertEqual(error.localizedDescription, testExpectationDescription)
                testExpectation.fulfill()
            })
            .disposed(by: DisposeBag())
        
        wait(for: [testExpectation], timeout: 1)
    }
    
    func test_makeUserDefaultStorageNotSupported_shouldOnError() {
        let `class` = StoragePointTests.self
        let function = "insert()"
        let testExpectationDescription = "\(String(describing: `class`)) -> \(function) is not available for UserDefaults"
        let testExpectation = expectation(description: testExpectationDescription)
        
        StoragePoint
            .makeUserDefaultStorageNotSupported(class: `class`, function: function, object: String.self)
            .subscribe(onError: { error in
                XCTAssertEqual(error.localizedDescription, testExpectationDescription)
                testExpectation.fulfill()
            })
            .disposed(by: DisposeBag())
        
        wait(for: [testExpectation], timeout: 1)
    }

}

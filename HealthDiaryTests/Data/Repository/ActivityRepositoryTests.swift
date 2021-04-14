//
//  ActivityRepositoryTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import DEV_Health_Diary

// MARK: ActivityRepositoryTests
class ActivityRepositoryTests: XCTestCase {

    private lazy var sut = self.makeActivityRepositorySUT()
    private var insertedObject: ActivityDomain!
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }

    override func tearDown() {
        self.removeStub()
        super.tearDown()
    }
    
    private func makeStub() {
        let activity = ActivityDomain.stubElement(coreDataStorage: self.sut.coreDataStorageMock)
        self.sut.localActivityStorage
            .insertIntoCoreData(activity)
            .subscribe(onNext: { [unowned self] object in
                self.insertedObject = object
            }, onCompleted: { [unowned self] in
                self.sut.semaphore.signal()
            })
            .disposed(by: self.sut.disposeBag)
        self.sut.semaphore.wait()
    }
    
    private func removeStub() {
        self.sut.localActivityStorage
            .removeInCoreData(self.insertedObject)
            .subscribe(onCompleted: { [unowned self] in
                self.sut.semaphore.signal()
            })
            .disposed(by: self.sut.disposeBag)
        self.sut.semaphore.wait()
    }

}

// MARK: Tests Function
extension ActivityRepositoryTests {
    
    func test_fetchAllActivity_whenStoragePointCoreData_thenFetchedInCoreData() throws {
        let timeout = self.sut.coreDataStorageMock.fetchCollectionTimeout
        
        let result = try self.sut.activityRepository
            .fetchAllActivity(in: .coreData)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.contains(self.insertedObject))
    }
    
    func test_fetchAllActivity_whenStoragePointUserDefault_thenObservePlainError() {
        let timeout = self.sut.coreDataStorageMock.removeElementTimeout
        
        let testExpectationDescription = "ActivityRepository: fetchAllActivity() is not available for UserDefaults"
        let testExpectation = expectation(description: testExpectationDescription)
        
        self.sut.activityRepository
            .fetchAllActivity(in: .userDefault)
            .subscribe(onError: { error in
                XCTAssertTrue(error is PlainError)
                XCTAssertEqual(testExpectation.description, testExpectationDescription)
                testExpectation.fulfill()
            })
            .disposed(by: self.sut.disposeBag)
        
        wait(for: [testExpectation], timeout: timeout)
    }
    
    func test_insertActivity_whenStoragePointCoreData_thenInsertedIntoCoreData() throws {
        let timeout = self.sut.coreDataStorageMock.insertElementTimeout
        
        let object = ActivityDomain.stubElement(coreDataStorage: self.sut.coreDataStorageMock)
        let storagePoint = StoragePoint.coreData
        
        let result = try self.sut.activityRepository
            .insertActivity(object, into: storagePoint)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(result.title, object.title)
    }
    
    func test_insertActivity_whenStoragePointUserDefaults_thenObserverPlainError() {
        let timeout = self.sut.coreDataStorageMock.removeElementTimeout
        
        let testExpectationDescription = "ActivityRepository: insertActivity() is not available for UserDefaults"
        let testExpectation = expectation(description: testExpectationDescription)
        let object = ActivityDomain.stubElement(coreDataStorage: self.sut.coreDataStorageMock)
        
        self.sut.activityRepository
            .insertActivity(object, into: .userDefault)
            .subscribe(onError: { error in
                XCTAssertTrue(error is PlainError)
                XCTAssertEqual(testExpectation.description, testExpectationDescription)
                testExpectation.fulfill()
            })
            .disposed(by: self.sut.disposeBag)
        
        wait(for: [testExpectation], timeout: timeout)
    }
    
}

// MARK: ActivityRepositorySUT
public struct ActivityRepositorySUT {
    
    public let semaphore: DispatchSemaphore
    public let disposeBag: DisposeBag
    public let coreDataStorageMock: CoreDataStorageSharedMock
    public let localActivityStorage: LocalActivityStorage
    public let activityRepository: ActivityRepository
    
}

public extension XCTest {
    
    func makeActivityRepositorySUT() -> ActivityRepositorySUT {
        let semaphore = self.makeSempahore()
        let disposeBag = self.makeDisposeBag()
        let coreDataStorageMock = self.makeCoreDataStorageMock()
        let localActivityStorage = DefaultLocalActivityStorage(coreDataStorage: coreDataStorageMock)
        let activityRepository = DefaultActivityRepository(localActivityStorage: localActivityStorage)
        return ActivityRepositorySUT(semaphore: semaphore,
                                     disposeBag: disposeBag,
                                     coreDataStorageMock: coreDataStorageMock,
                                     localActivityStorage: localActivityStorage,
                                     activityRepository: activityRepository)
    }
    
}

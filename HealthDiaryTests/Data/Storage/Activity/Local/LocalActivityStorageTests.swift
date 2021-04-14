//
//  LocalActivityStorageTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 21/03/21.
//

import CoreData
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import DEV_Health_Diary

// MARK: LocalActivityStorageTests
class LocalActivityStorageTests: XCTestCase {

    private lazy var sut: LocalActivityStorageSUT = {
        return self.makeLocalActivityStorageSUT()
    }()
    private var insertedActivities: [ActivityDomain] = []
    private var insertedActivity: ActivityDomain!
    private var removedActivity: ActivityDomain!
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        self.removeStub()
        super.tearDown()
    }
    
    private func makeStub() {
        let context = self.sut.coreDataStorageMock.context
        let stubCollection = ActivityDomain.stubCollection(coreDataStorage: self.sut.coreDataStorageMock)
        let stubElement = ActivityDomain.stubElement(coreDataStorage: self.sut.coreDataStorageMock)
        let stubRemoveElement = ActivityDomain.stubRemoveElement(coreDataStorage: self.sut.coreDataStorageMock)
        var insertedEntities = stubCollection.map { ActivityEntity($0, insertInto: context) }
        let insertedEntity = ActivityEntity(stubElement, insertInto: context)
        let removedEntity = ActivityEntity(stubRemoveElement, insertInto: context)
        self.removedActivity = removedEntity.toDomain(context: context)
        context.delete(removedEntity)
        self.sut.coreDataStorageMock.saveContext()
        insertedEntities.append(insertedEntity)
        self.insertedActivity = insertedEntity.toDomain(context: context)
        self.insertedActivities = insertedEntities
            .map { $0.toDomain(context: context) }
            .sorted { $0.title < $1.title }
    }
    
    private func removeStub() {
        let context = self.sut.coreDataStorageMock.context
        let request: NSFetchRequest = ActivityEntity.fetchRequest()
        let workspaces = try! context.fetch(request)
        workspaces.forEach { context.delete($0) }
        self.sut.coreDataStorageMock.saveContext()
    }

}

// MARK: Tests Function
extension LocalActivityStorageTests {
    
    func test_fetchAllActivityInCoreData_shouldFetchedInCoreData() throws {
        let timeout = self.sut.coreDataStorageMock.fetchCollectionTimeout
        
        let result = try self.sut.localActivityStorage
            .fetchAllInCoreData()
            .toBlocking(timeout: timeout)
            .single()
            .sorted { $0.title < $1.title }
        
        XCTAssertTrue(!result.isEmpty)
        XCTAssertEqual(result, self.insertedActivities)
    }
    
    func test_insertIntoCoreData_shouldInsertedIntoCoreData() throws {
        let timeout = self.sut.coreDataStorageMock.insertElementTimeout
        
        let object = ActivityDomain.stubElement(coreDataStorage: self.sut.coreDataStorageMock)
        
        let result = try self.sut.localActivityStorage
            .insertIntoCoreData(object)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(result.title, object.title)
    }
    
    func test_insertIntoCoreData_whenCoreIdAlreadyInserted_then() throws {
        let timeout = self.sut.coreDataStorageMock.insertElementTimeout
        
        let object = self.insertedActivity!
        let updateObject = ActivityDomain(coreID: object.coreID,
                                          createdAt: object.createdAt,
                                          updatedAt: object.updatedAt,
                                          doDate: object.doDate,
                                          explanation: "Activity Updated Test",
                                          isArchived: false,
                                          isPinned: false,
                                          photoFileNames: [],
                                          title: "Activity Updated Test",
                                          profile: object.profile)
        
        let result = try self.sut.localActivityStorage
            .insertIntoCoreData(updateObject)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(result.coreID, updateObject.coreID)
        XCTAssertEqual(result.title, updateObject.title)
        XCTAssertNotEqual(result.title, object.title)
    }
    
    func test_removeInCoreData_shouldRemovedInCoreData() throws {
        let timeout = self.sut.coreDataStorageMock.removeElementTimeout
        
        let result = try self.sut.localActivityStorage
            .removeInCoreData(self.insertedActivity)
            .toBlocking(timeout: timeout)
            .single()
        
        XCTAssertEqual(result.coreID, self.insertedActivity.coreID)
    }
    
    func test_removeInCoreData_whenObjectDoesNotHaveCoreId_thenCoreDataDeleteError() {
        let timeout = self.sut.coreDataStorageMock.removeElementTimeout
        
        let testExpectationDescription = "LocalActivityStorage: Failed to execute removeInCoreData(_:) caused by coreId is not available"
        let testExpectation = expectation(description: testExpectationDescription)
        let object = ActivityDomain.stubElement(coreDataStorage: self.sut.coreDataStorageMock)
        
        self.sut.localActivityStorage
            .removeInCoreData(object)
            .subscribe(onError: { error in
                XCTAssertTrue(error is CoreDataStorageError)
                XCTAssertEqual(testExpectation.description, testExpectationDescription)
                testExpectation.fulfill()
            })
            .disposed(by: self.sut.disposeBag)
        
        wait(for: [testExpectation], timeout: timeout)
    }
    
}

// MARK: LocalActivityStorageSUT
public struct LocalActivityStorageSUT {
    
    public let semaphore: DispatchSemaphore
    public let disposeBag: DisposeBag
    public let coreDataStorageMock: CoreDataStorageSharedMock
    public let localActivityStorage: LocalActivityStorage
    
}

public extension XCTest {
    
    func makeLocalActivityStorageSUT() -> LocalActivityStorageSUT {
        let semaphore = self.makeSempahore()
        let disposeBag = self.makeDisposeBag()
        let coreDataStorageMock = self.makeCoreDataStorageMock()
        let localActivityStorage = DefaultLocalActivityStorage(coreDataStorage: coreDataStorageMock)
        return LocalActivityStorageSUT(semaphore: semaphore,
                                       disposeBag: disposeBag,
                                       coreDataStorageMock: coreDataStorageMock,
                                       localActivityStorage: localActivityStorage)
    }
    
}

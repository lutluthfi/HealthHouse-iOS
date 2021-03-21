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

class LocalActivityStorageTests: XCTestCase {

    private lazy var sut: LocalActivityStorageSUT = {
        return self.makeLocalActivityStorageSUT()
    }()
    private var insertedObjects: [ActivityDomain] = []
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        self.removeStub()
        super.tearDown()
    }
    
    private func makeStub() {
        let workspace = ActivityDomain.stubCollection
        let insertedEntities = workspace.map {
            ActivityEntity($0, insertInto: self.sut.coreDataStorageMock.context)
        }
        try! self.sut.coreDataStorageMock.context.save()
        self.insertedObjects = insertedEntities.map { $0.toDomain() }.sorted(by: { $0.title < $1.title })
    }
    
    private func removeStub() {
        let context = self.sut.coreDataStorageMock.context
        let request: NSFetchRequest = ActivityEntity.fetchRequest()
        let workspaces = try! context.fetch(request)
        workspaces.forEach { context.delete($0) }
        try! context.save()
    }

}

extension LocalActivityStorageTests {
    
    func test_fetchAllActivity_shouldFetchedFromCoreData() throws {
        let result = try self.sut.localActivityStorage
            .fetchAllActivity()
            .toBlocking(timeout: self.sut.coreDataStorageMock.fetchCollectionTimeout)
            .single()
            .sorted(by: { $0.title < $1.title })
        
        XCTAssertTrue(!result.isEmpty)
        XCTAssertEqual(result, self.insertedObjects)
    }
    
    func test_insertIntoCoreData_shouldInsertedIntoCoreData() throws {
        let now = Date().toInt64()
        let activity = ActivityDomain(createdAt: now, updatedAt: now, icon: "icon", notes: "notes", title: "title")
        let result = try self.sut.localActivityStorage
            .insertIntoCoreData(activity)
            .toBlocking(timeout: self.sut.coreDataStorageMock.insertElementTimeout)
            .single()
        
        XCTAssertNotNil(result.coreId)
        XCTAssertEqual(result.title, activity.title)
    }
    
}

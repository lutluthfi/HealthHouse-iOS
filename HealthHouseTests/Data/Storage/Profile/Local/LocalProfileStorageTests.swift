//
//  LocalProfileStorageTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 18/04/21.
//

import CoreData
import RxSwift
import XCTest
@testable import DEV_Health_Diary

class LocalProfileStorageTests: XCTestCase {

    private lazy var sut = self.makeLocalProfileStorageSUT()
    
    private var insertedProfileCollection: [ProfileDomain] = []
    private var insertedProfileElement: ProfileDomain!
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        self.removeStub()
        super.tearDown()
    }
    
    private func makeStub() {
        let coreDataStorage = self.sut.coreDataStorage
        self.insertedProfileCollection = ProfileDomain.stubCollectionCoreData(coreDataStorage: coreDataStorage)
        self.insertedProfileElement = ProfileDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
        self.insertedProfileCollection.append(self.insertedProfileElement)
        self.insertedProfileCollection.sort(by: { $0.firstName < $1.firstName })
        _ = try! self.sut.userDefaultsProfileStorage
            .insertIntoUserDefaults(self.insertedProfileElement)
            .toBlocking()
            .single()
    }
    
    private func removeStub() {
        let context = self.sut.coreDataStorage.context
        let request: NSFetchRequest = ProfileEntity.fetchRequest()
        let profileEntities = try! context.fetch(request)
        profileEntities.forEach { context.delete($0) }
        self.sut.coreDataStorage.saveContext()
        self.removeUserDefaults()
    }

}

extension LocalProfileStorageTests {
    
    func test_fetchAllInCoreData_shouldFetchedInCoreData() throws {
        let result = try self.sut.storage
            .fetchAllInCoreData()
            .toBlocking()
            .single()
            .sorted(by: { $0.firstName < $1.firstName })
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result, self.insertedProfileCollection)
    }
    
    func test_insertIntoCoreData_shouldInsertedInCoreData() throws {
        let object = ProfileDomain.stubElement
        
        let result = try self.sut.storage
            .insertIntoCoreData(object)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(result.firstName, object.firstName)
    }
    
    func test_removeInCoreData_shouldRemovedInCoreData() throws {
        let object = self.insertedProfileElement!
        
        let result = try self.sut.storage
            .removeInCoreData(object)
            .toBlocking()
            .single()
        
        XCTAssertEqual(object, result)
    }
    
}

extension LocalProfileStorageTests {
    
    func test_fetchInUserDefaults_shouldFetchedInUserDefaults() throws {
        let result = try self.sut.userDefaultsProfileStorage
            .fetchInUserDefaults()
            .toBlocking()
            .single()

        XCTAssertNotNil(self.insertedProfileElement.coreID)
        XCTAssertEqual(result, self.insertedProfileElement.coreID?.uriRepresentation())
    }

    func test_insertIntoUserDefaults_shouldInsertedIntoUserDefaults() throws {
        let object = ProfileDomain.stubElementCoreData(coreDataStorage: self.sut.coreDataStorage)

        let result = try self.sut.userDefaultsProfileStorage
            .insertIntoUserDefaults(object)
            .toBlocking()
            .single()

        XCTAssertEqual(result, object)
    }
    
}

struct LocalProfileStorageSUT {
    
    let coreDataStorage: CoreDataStorageSharedMock
    let storage: LocalProfileStorage
    let userDefaultsProfileStorage: UserDefaultsProfileStorage
    
}

extension XCTest {
    
    func makeLocalProfileStorageSUT() -> LocalProfileStorageSUT {
        let coreDataStorage = self.makeCoreDataStorageMock()
        let userDefaults = self.makeUserDefaults()
        let userDefaultsProfileStorage = DefaultUserDefaultsProfileStorage(userDefaults: userDefaults)
        let storage = DefaultLocalProfileStorage(coreDataStorage: coreDataStorage,
                                                 userDefaultsProfileStorage: userDefaultsProfileStorage)
        return LocalProfileStorageSUT(coreDataStorage: coreDataStorage,
                                      storage: storage,
                                      userDefaultsProfileStorage: userDefaultsProfileStorage)
    }
    
}

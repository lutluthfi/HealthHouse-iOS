//
//  UserDefaultsProfileStorageTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import DEV_Health_Diary

class UserDefaultsProfileStorageTests: XCTestCase {

    private lazy var sut = self.makeUserDefaultsProfileStorageSUT()
    private var insertedObject: ProfileDomain!
    
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
        self.insertedObject = ProfileDomain.stubElementCoreData(coreDataStorage: coreDataStorage)
        self.sut.userDefaults.set(self.insertedObject.coreID?.uriRepresentation(),
                                  forKey: "ProfileCoreIDKey.UserDefaultsProfileStorage")
    }
    
    private func removeStub() {
        self.removeUserDefaults()
    }

}

extension UserDefaultsProfileStorageTests {
    
    func test_fetchInUserDefaults_shouldFetchedInUserDefaults() throws {
        let result = try self.sut.userDefaultsProfileStorage
            .fetchInUserDefaults()
            .toBlocking(timeout: TimeInterval(2))
            .single()
        
        XCTAssertEqual(result, self.insertedObject.coreID?.uriRepresentation())
    }
    
    func test_insertIntoUserDefaults_shouldInsertedIntoUserDefaults() throws {
        let object = ProfileDomain.stubElementCoreData(coreDataStorage: self.sut.coreDataStorage)
        
        let result = try self.sut.userDefaultsProfileStorage
            .insertIntoUserDefaults(object)
            .toBlocking(timeout: TimeInterval(2))
            .single()
        
        XCTAssertEqual(result, object)
    }
    
}

struct UserDefaultsProfileStorageSUT {
    
    let coreDataStorage: CoreDataStorageSharedMock
    let userDefaults: UserDefaults
    let userDefaultsProfileStorage: UserDefaultsProfileStorage
    
}

extension XCTest {
    
    func makeUserDefaultsProfileStorageSUT() -> UserDefaultsProfileStorageSUT {
        let coreDataStorage = self.makeCoreDataStorageMock()
        let userDefaults = self.makeUserDefaults()
        let userDefaultsProfileStorage = DefaultUserDefaultsProfileStorage(userDefaults: userDefaults)
        return UserDefaultsProfileStorageSUT(coreDataStorage: coreDataStorage,
                                             userDefaults: userDefaults,
                                             userDefaultsProfileStorage: userDefaultsProfileStorage)
    }
    
}

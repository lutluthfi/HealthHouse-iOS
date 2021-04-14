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
        let context = self.sut.coreDataStorage.context
        let insertedEntity = ProfileEntity(.stubElement, insertInto: context)
        self.sut.coreDataStorage.saveContext()
        self.insertedObject = insertedEntity.toDomain()
        self.sut.userDefaults.set(self.insertedObject.coreID?.uriRepresentation(),
                                  forKey: "ProfileCoreIDKey.UserDefaultsProfileStorage")
    }
    
    private func removeStub() {
        self.sut.userDefaults.removePersistentDomain(forName: #file)
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
        let object = ProfileDomain.stubElementInsertedIntoCoreData
        
        let result = try self.sut.userDefaultsProfileStorage
            .insertIntoUserDefaults(object)
            .toBlocking(timeout: TimeInterval(2))
            .single()
        
        XCTAssertEqual(result, object)
    }
    
}

public struct UserDefaultsProfileStorageSUT {
    
    public let semaphore: DispatchSemaphore
    public let disposeBag: DisposeBag
    public let coreDataStorage: CoreDataStorageSharedMock
    public let userDefaults: UserDefaults
    public let userDefaultsProfileStorage: UserDefaultsProfileStorage
    
}

public extension XCTest {
    
    func makeUserDefaultsProfileStorageSUT() -> UserDefaultsProfileStorageSUT {
        let semaphore = self.makeSempahore()
        let disposeBag = self.makeDisposeBag()
        let coreDataStorage = self.makeCoreDataStorageMock()
        let userDefaults = UserDefaults(suiteName: #file)!
        let userDefaultsProfileStorage = DefaultUserDefaultsProfileStorage(userDefaults: UserDefaults(suiteName: #file)!)
        return UserDefaultsProfileStorageSUT(semaphore: semaphore,
                                             disposeBag: disposeBag,
                                             coreDataStorage: coreDataStorage,
                                             userDefaults: userDefaults,
                                             userDefaultsProfileStorage: userDefaultsProfileStorage)
    }
    
}

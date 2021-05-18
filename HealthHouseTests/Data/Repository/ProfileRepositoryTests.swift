//
//  ProfileRepositoryTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 18/04/21.
//

import RxSwift
import XCTest
@testable import Health_House

class ProfileRepositoryTests: XCTestCase {

    private lazy var sut = self.makeProfileRepositorySUT()
    private var insertedProfile: ProfileDomain!
    
    override func setUp() {
        self.makeStub()
        super.setUp()
        
    }
    
    override func tearDown() {
        self.clearCoreDataStorage()
        super.tearDown()
    }
    
    private func makeStub() {
        self.insertedProfile = try! self.sut.localProfileStorage
            .insertIntoCoreData(.stubElement)
            .toBlocking()
            .single()
    }

}

extension ProfileRepositoryTests {
    
    func test_fetchAllProfile_whenStoragePointCoreData_thenFetchedAllProfileInCoreData() throws {
        let result = try self.sut.repository
            .fetchAllProfile(in: .coreData)
            .toBlocking()
            .single()
        
        XCTAssertTrue(result.contains(self.insertedProfile!))
    }
    
    func test_fetchAllProfile_whenStoragePointRemote_thenThrowsError() throws {
        XCTAssertThrowsError(try self.sut.repository
                                .fetchAllProfile(in: .remote)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "ProfileRepository -> fetchAllProfile() is not available for Remote")
        }
    }
    
    func test_fetchAllProfile_whenStorageUserDefault_thenThrowsError() throws {
        XCTAssertThrowsError(try self.sut.repository
                                .fetchAllProfile(in: .userDefaults)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "ProfileRepository -> fetchAllProfile() is not available for UserDefaults")
        }
    }
    
    func test_insertProfile_whenStoragePointCoreData_thenInsertedIntoCoreData() throws {
        let object = ProfileDomain.stubElement
        
        let result = try self.sut.repository
            .insertUpdateProfile(object, into: .coreData)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.coreID)
        XCTAssertEqual(result.firstName, object.firstName)
    }
    
    func test_insertProfile_whenStoragePointRemote_thenThrowsError() throws {
        let object = ProfileDomain.stubElement
        
        XCTAssertThrowsError(try self.sut.repository
                                .insertUpdateProfile(object, into: .remote)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "ProfileRepository -> insertUpdateProfile() is not available for Remote")
        }
    }
    
    func test_insertProfile_whenStoragePointUserDefaultsAndObjectCoreData_thenInsertedIntoUserDefaults() throws {
        let object = self.insertedProfile!
        
        let result = try self.sut.repository
            .insertUpdateProfile(object, into: .userDefaults)
            .toBlocking()
            .single()
        
        XCTAssertEqual(result, object)
    }
    
    func test_insertProfile_whenStoragePointUserDefaultsAndObjectNotCoreData_thenThrowsError() throws {
        let object = ProfileDomain.stubElement
        
        XCTAssertThrowsError(try self.sut.repository
                                .insertUpdateProfile(object, into: .userDefaults)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "UserDefaultsProfileStorage -> Failed to insertIntoUserDefaults() caused by coreID is nil")
        }
    }
    
    func test_removeProfile_whenStoragePointCoreData_thenRemovedInCoreData() throws {
        let object = self.insertedProfile!
        
        let result = try self.sut.repository
            .removeProfile(object, in: .coreData)
            .toBlocking()
            .single()
        
        XCTAssertEqual(result, object)
    }
    
    func test_removeProfile_whenStoragePointRemote_thenThrowsError() throws {
        let object = self.insertedProfile!
        
        XCTAssertThrowsError(try self.sut.repository
                                .removeProfile(object, in: .remote)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "ProfileRepository -> removeProfile() is not available for Remote")
        }
    }
    
    func test_removeProfile_whenStoragePointUserDefaults_thenThrowsError() throws {
        let object = self.insertedProfile!
        
        XCTAssertThrowsError(try self.sut.repository
                                .removeProfile(object, in: .userDefaults)
                                .toBlocking()
                                .single()) { (error) in
            XCTAssertTrue(error is PlainError)
            XCTAssertEqual(error.localizedDescription, "ProfileRepository -> removeProfile() is not available for UserDefaults")
        }
    }
    
}

struct ProfileRepositorySUT {
    
    let localProfileStorage: LocalProfileStorage
    let repository: ProfileRepository
    
}

extension XCTest {
    
    func makeProfileRepositorySUT() -> ProfileRepositorySUT {
        let userDefaults = UserDefaults(suiteName: #file)!
        let coreDataStorage = self.makeCoreDataStorageMock()
        let userDefaultsProfileStorage = DefaultUserDefaultsProfileStorage(userDefaults: userDefaults)
        let localProfileStorage = DefaultLocalProfileStorage(coreDataStorage: coreDataStorage,
                                                             userDefaultsProfileStorage: userDefaultsProfileStorage)
        let repository = DefaultProfileRepository(localProfileStorage: localProfileStorage)
        return ProfileRepositorySUT(localProfileStorage: localProfileStorage, repository: repository)
    }
    
}

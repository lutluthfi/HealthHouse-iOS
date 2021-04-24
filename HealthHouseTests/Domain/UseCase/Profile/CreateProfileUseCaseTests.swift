//
//  CreateProfileUseCaseTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 18/04/21.
//

import XCTest
@testable import DEV_Health_Diary

class CreateProfileUseCaseTests: XCTestCase {

    private lazy var sut = self.makeCreateProfileUseCaseSUT()
    
    func test_execute_shouldInsertedIntoCoreData() throws {
        let firstName = "FirstName"
        let lastName = "LastName"
        let dateOfBirth = Date()
        let gender = GenderDomain.male
        let mobileNumber = "1234567890"
        let photo = UIImage()
        
        let request = CreateProfileUseCaseRequest(firstName: firstName,
                                                  dateOfBirth: dateOfBirth,
                                                  gender: gender,
                                                  lastName: lastName,
                                                  mobileNumber: mobileNumber,
                                                  photo: photo)
        let result = try self.sut.useCase
            .execute(request)
            .toBlocking()
            .single()
        
        XCTAssertNotNil(result.profile.coreID)
        XCTAssertEqual(result.profile.firstName, firstName)
        XCTAssertEqual(result.profile.lastName, lastName)
        XCTAssertEqual(result.profile.dateOfBirth, dateOfBirth.toInt64())
        XCTAssertEqual(result.profile.gender, gender)
        XCTAssertEqual(result.profile.mobileNumbder, mobileNumber)
        XCTAssertEqual(result.profile.photoBase64String, photo.pngData()?.base64EncodedString())
    }
   
}

struct CreateProfileUseCaseSUT {
    
    let profileRepository: ProfileRepository
    let useCase: CreateProfileUseCase
    
}

extension XCTest {
    
    func makeCreateProfileUseCaseSUT() -> CreateProfileUseCaseSUT {
        let coreDataStorage = self.makeCoreDataStorageMock()
        let userDefaults = self.makeUserDefaults()
        let userDefualtsProfileStorage = DefaultUserDefaultsProfileStorage(userDefaults: userDefaults)
        let localProfileStorage = DefaultLocalProfileStorage(coreDataStorage: coreDataStorage,
                                                             userDefaultsProfileStorage: userDefualtsProfileStorage)
        let profileRepository = DefaultProfileRepository(localProfileStorage: localProfileStorage)
        let useCase = DefaultCreateProfileUseCase(profileRepository: profileRepository)
        return CreateProfileUseCaseSUT(profileRepository: profileRepository, useCase: useCase)
    }
    
}

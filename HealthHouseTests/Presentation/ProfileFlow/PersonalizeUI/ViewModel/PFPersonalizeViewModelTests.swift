//
//  PFPersonalizeViewModelTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 12/04/21.
//

import RxSwift
import XCTest
@testable import DEV_Health_Diary

class PFPersonalizeViewModelTests: XCTestCase {

    private lazy var sut = self.makePFPersonalizeViewModelSUT()

    func test_doCreate() {
        let _resultExpectation = AnyResult<String, String>.success("Health Diary has been created.\nWe hope you are always healthy 🥳")
        let _responseExpectation = PFPersonalizeViewModelResponse.DoCreate(_resultExpectation)
        var _response: PFPersonalizeViewModelResponse?
        let subscription = self.sut.viewModel
            .response
            .subscribe(onNext: { _response = $0 })
        
        self.sut.viewModel.doCreate(firstName: "Health",
                                    dateOfBirth: Date(),
                                    gender: .male,
                                    lastName: "Diary",
                                    mobileNumber: "1234567890",
                                    photo: UIImage())
        
        eventually {
            subscription.dispose()
            XCTAssertNotNil(_response)
            XCTAssertEqual(_response, _responseExpectation)
        }
    }
    
    func test_viewDidLoad_shouldFetchedCountryDialingCode() {
        var _countryDialingCodes: [CountryDialingCodeDomain] = []
        let subscription = self.sut.viewModel
            .showedCountryDialingCodes
            .subscribe(onNext: { _countryDialingCodes = $0 })
        
        self.sut.viewModel.viewDidLoad()
        
        eventually {
            subscription.dispose()
            XCTAssertFalse(_countryDialingCodes.isEmpty)
            XCTAssertTrue(_countryDialingCodes.contains(.indonesia))
        }
    }

}

struct PFPersonalizeViewModelSUT {
    
    let viewModel: PFPersonalizeViewModel
    
}

extension XCTest {
    
    func makePFPersonalizeViewModelSUT() -> PFPersonalizeViewModelSUT {
        let createProfileUseCase = self.makeCreateProfileUseCaseSUT()
        let fetchCountryDialingCodeUseCase = self.makeFetchCountryDialingCodeUseCaseSUT()
        let request = PFPersonalizeViewModelRequest()
        let route = PFPersonalizeViewModelRoute()
        let viewModel = DefaultPFPersonalizeViewModel(request: request,
                                                      route: route,
                                                      createProfileUseCase: createProfileUseCase.useCase,
                                                      fetchCountryDialingCodeUseCase: fetchCountryDialingCodeUseCase.useCase)
        return PFPersonalizeViewModelSUT(viewModel: viewModel)
    }
    
}

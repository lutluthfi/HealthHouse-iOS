//
//  PFPersonalizeViewModelTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 12/04/21.
//

import RxSwift
import XCTest
@testable import Health_House

class PFPersonalizeViewModelTests: XCTestCase {

    private lazy var sut = self.makePFPersonalizeViewModelSUT()

    func test_doCreate() {
        let _resultExpectation = AnyResult<String, String>.success("Health Diary has been created.\nWe hope you are always healthy 🥳")
        let _responseExpectation = PFPersonalizeViewModelResult.DoCreate(_resultExpectation)
        var _response: PFPersonalizeViewModelResult?
        let subscription = self.sut.viewModel.result.subscribe(onNext: { _response = $0 })
        
        self.sut.viewModel.doCreate(dateOfBirth: Date(),
                                    firstName: "Health",
                                    gender: .male,
                                    lastName: "Diary",
                                    mobileNumber: "1234567890",
                                    photo: UIImage())
        
        eventually(timeoutAfter: 5, timeoutExpectation: 5) {
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
        
        eventually(timeoutAfter: 5, timeoutExpectation: 5) {
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

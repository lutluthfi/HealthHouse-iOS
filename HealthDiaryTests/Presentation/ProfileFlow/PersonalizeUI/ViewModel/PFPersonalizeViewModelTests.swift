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
    
    func test_viewDidLoad_shouldFetchedCountryDialingCode() {
        var _countryDialingCodes: [CountryDialingCodeDomain] = []
        let subscription = self.sut.viewModel
            .showedCountryDialingCodes
            .subscribe(onNext: { _countryDialingCodes = $0 })
        
        self.sut.viewModel.viewDidLoad()
        
        eventually(timeoutAfter: TimeInterval(5)) {
            subscription.dispose()
            XCTAssertTrue(!_countryDialingCodes.isEmpty)
            XCTAssertTrue(_countryDialingCodes.contains(.indonesia))
        }
    }

}

struct PFPersonalizeViewModelSUT {
    
    let viewModel: PFPersonalizeViewModel
    
}

extension XCTest {
    
    func makePFPersonalizeViewModelSUT() -> PFPersonalizeViewModelSUT {
        let fetchCountryDialingCodeUseCase = self.makeFetchCountryDialingCodeUseCaseSUT()
        let requestValue = PFPersonalizeViewModelRequestValue()
        let route = PFPersonalizeViewModelRoute()
        let viewModel = DefaultPFPersonalizeViewModel(requestValue: requestValue,
                                                      route: route,
                                                      fetchCountryDialingCodeUseCase: fetchCountryDialingCodeUseCase.useCase)
        return PFPersonalizeViewModelSUT(viewModel: viewModel)
    }
    
}

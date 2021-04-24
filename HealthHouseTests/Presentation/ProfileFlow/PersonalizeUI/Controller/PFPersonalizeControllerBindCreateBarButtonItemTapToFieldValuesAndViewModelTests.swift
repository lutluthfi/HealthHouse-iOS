//
//  PFPersonalizeControllerBindCreateBarButtonItemTapToFieldValuesAndViewModelTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 19/04/21.
//

import RxSwift
import XCTest
@testable import DEV_Health_Diary

class PFPersonalizeControllerBindCreateBarButtonItemTapToFieldValuesAndViewModelTests: XCTestCase {
    
    private lazy var sut = self.makePFPersonalizeControllerSUT()
    
    func test_bindCreateBarButtonItemTapToFieldValuesAndViewModel() {
        let element = (Date(), "Health", GenderDomain.male, "Diary", "1234567890", UIImage())
        let observable = Observable<(Date, String, GenderDomain, String, String, UIImage?)>.just(element)
        let barButtonItem = UIBarButtonItem()
        self.sut.controller
            .bindCreateBarButtonItemTapToFieldValuesAndViewModel(barButtonItem: barButtonItem,
                                                                 observable: observable,
                                                                 viewModel: self.sut.viewModel)
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: self, for: nil)
    }
    
}

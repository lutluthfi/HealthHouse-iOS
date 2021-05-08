//
//  PFPersonalizeControllerBindCreateBarButtonItemTapToFieldValuesAndViewModelTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 19/04/21.
//

import RxSwift
import XCTest
@testable import Health_House

class PFPersonalizeControllerBindCreateBarButtonItemTapToFieldValuesAndViewModelTests: XCTestCase {
    
    private lazy var sut = self.makePFPersonalizeControllerSUT()
    
    func test_bindCreateBarButtonItemTapToFieldValuesAndViewModel() {
        let element = (Date(), "Health", GenderDomain.male, "Diary", "1234567890", UIImage())
        let observable = Observable<(Date, String, GenderDomain, String, String, UIImage?)>.just(element)
        let barButtonItem = UIBarButtonItem()
        self.sut.controller.bindCreateBarButtonItemTapToFieldValues(barButtonItem: barButtonItem,
                                                                    observable: observable)
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: self, for: nil)
    }
    
}

//
//  PFPersonalizeControllerBindGenderToPickerTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 17/04/21.
//

import XCTest
@testable import DEV_Health_Diary

class PFPersonalizeControllerBindGenderToPickerTests: XCTestCase {

    private lazy var sut = self.makePFPersonalizeControllerSUT()

    func test_bindGenderToPicker_shouldHoldAllGender() {
        let picker = UIPickerView()
        self.sut.controller.bindGenderToPicker(picker: picker)
        
        XCTAssertEqual(GenderDomain.allCases.count, picker.numberOfRows(inComponent: 0))
    }
    
}

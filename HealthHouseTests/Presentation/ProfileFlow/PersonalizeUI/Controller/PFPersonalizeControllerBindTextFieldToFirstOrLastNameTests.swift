//
//  PFPersonalizeControllerBindTextFieldToFirstOrLastNameTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 12/04/21.
//

import RxSwift
import XCTest
@testable import DEV_Health_Diary

class PFPersonalizeControllerBindTextFieldToFirstOrLastNameTests: XCTestCase {

    private lazy var sut = self.makePFPersonalizeControllerSUT()
    
    func test_bindTextFieldToString_whenTextFirstOrLastNameValid_thenSubjectSubscibeString() {
        let subject = BehaviorSubject<String>(value: "")
        let textField = UITextField()
        
        self.sut.controller.bindTextFieldToFirstOrLastName(textField: textField, subject: subject)
        
        textField.text = "BindTextFieldToString"
        textField.sendActions(for: .editingChanged)
        
        subject.subscribe(onNext: { (string) in
            XCTAssertEqual(string, "BindTextFieldToString")
        }).disposed(by: self.sut.disposeBag)
    }
    
    func test_bindTextFieldToString_whenTextNotFirstOrLastNameValid_thenSubjectSubscibeNil() {
        let subject = BehaviorSubject<String>(value: "")
        let textField = UITextField()
        
        self.sut.controller.bindTextFieldToFirstOrLastName(textField: textField, subject: subject)
        
        textField.text = "BindTextFieldToString 123"
        textField.sendActions(for: .editingChanged)
        
        subject.subscribe(onNext: { (string) in
            XCTAssertEqual(string, "")
        }).disposed(by: self.sut.disposeBag)
    }

}

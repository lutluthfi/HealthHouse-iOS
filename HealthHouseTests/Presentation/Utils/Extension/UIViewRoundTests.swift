//
//  UIViewRoundTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 30/03/21.
//

import UIKit
import XCTest
@testable import DEV_Health_Diary

class UIViewRoundTests: XCTestCase {

    func test_makeRound_whenDefaultParams_shouldSuccess() {
        let view = UIView()
        
        view.makeRound()
        
        XCTAssertTrue(view.clipsToBounds)
        XCTAssertEqual(view.layer.borderColor, nil)
        XCTAssertEqual(view.layer.borderWidth, 0)
        XCTAssertEqual(view.layer.cornerRadius, 8)
        XCTAssertEqual(view.layer.maskedCorners, [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
    }
    
    func test_makeRound_whenMaskingCorner_shouldSuccess() {
        let view = UIView()
        
        view.makeRound(maskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        XCTAssertTrue(view.clipsToBounds)
        XCTAssertEqual(view.layer.borderColor, nil)
        XCTAssertEqual(view.layer.borderWidth, 0)
        XCTAssertEqual(view.layer.cornerRadius, 8)
        XCTAssertEqual(view.layer.maskedCorners, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }

}

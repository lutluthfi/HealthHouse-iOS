//
//  LNWelcomeViewTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 30/03/21.
//

import XCTest
@testable import DEV_Health_Diary

class LNWelcomeViewTests: XCTestCase {

    private lazy var navigationController = UINavigationController()
    private lazy var view: LNWelcomeView = DefaultLNWelcomeView()
    
    func test_viewWillAppear() {
        let navigationBar = self.navigationController.navigationBar
        let navigationItem = self.navigationController.navigationItem
        let tabBarController = self.navigationController.tabBarController
        
        self.view.viewWillAppear(navigationBar: navigationBar,
                                 navigationItem: navigationItem,
                                 tabBarController: tabBarController)
        
        XCTAssertTrue(navigationBar.isHidden)
    }
    
    func test_showContinueButton() {
        let testExpectation = self.expectation(description: "Show continue button with animate 0.5 second")
        
        XCTAssertTrue(self.view.continueButton.isHidden)
        
        self.view.showContinueButton { _ in
            testExpectation.fulfill()
        }
        
        self.wait(for: [testExpectation], timeout: 5)
        
        XCTAssertFalse(self.view.continueButton.isHidden)
    }

}

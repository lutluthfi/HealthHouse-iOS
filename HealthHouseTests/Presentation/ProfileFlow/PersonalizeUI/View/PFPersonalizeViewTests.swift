//
//  PFPersonalizeViewTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 12/04/21.
//

import XCTest
@testable import Health_House

class PFPersonalizeViewTests: XCTestCase {

    private lazy var sut = self.makePFPersonalizeViewSUT()
    
    func test_viewWillAppear() {
        let navigationController = self.sut.navigationController
        let navigationItem = self.sut.navigationController.navigationItem
        let tabBarController = self.sut.tabBarController
        self.sut.view.viewWillAppear(navigationController: navigationController,
                                     navigationItem: navigationItem,
                                     tabBarController: tabBarController)
        
        eventually { [unowned self, unowned navigationController, unowned navigationItem] in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertFalse(navigationController.isNavigationBarHidden)
            XCTAssertTrue(navigationItem.hidesBackButton)
            XCTAssertEqual(navigationItem.rightBarButtonItems, [self.sut.view.createBarButtonItem])
        }
    }

}

struct PFPersonalizeViewSUT {
    
    let view: PFPersonalizeView
    
    let navigationController: UINavigationController
    let tabBarController: UITabBarController
    
}

extension XCTest {
    
    func makePFPersonalizeViewSUT() -> PFPersonalizeViewSUT {
        let view = DefaultPFPersonalizeView()
        let navigationController = UINavigationController()
        let tabBarController = UITabBarController()
        return PFPersonalizeViewSUT(view: view,
                                    navigationController: navigationController,
                                    tabBarController: tabBarController)
    }
    
}

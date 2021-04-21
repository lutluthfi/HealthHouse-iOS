//
//  LNWelcomeControllerTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import DEV_Health_Diary

class LNWelcomeControllerTests: XCTestCase {

    private lazy var controller: LNWelcomeController = {
        let request = LNWelcomeViewModelRequest()
        let route = LNWelcomeViewModelRoute()
        let viewModel: LNWelcomeViewModel = DefaultLNWelcomeViewModel(request: request, route: route)
        let controller = LNWelcomeController.create(with: viewModel)
        return controller
    }()
    
    func test() {
    }

}

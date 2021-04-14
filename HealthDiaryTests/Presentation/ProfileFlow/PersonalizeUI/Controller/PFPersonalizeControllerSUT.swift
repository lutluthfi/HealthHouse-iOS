//
//  PFPersonalizeControllerSUT.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 12/04/21.
//

import XCTest
@testable import DEV_Health_Diary

struct PFPersonalizeControllerSUT {
    
    let controller: PFPersonalizeController
    
}

extension XCTest {
    
    func makePFPersonalizeControllerSUT() -> PFPersonalizeControllerSUT {
        let viewModel = self.makePFPersonalizeViewModelSUT()
        let controller = PFPersonalizeController.create(with: viewModel.viewModel)
        return PFPersonalizeControllerSUT(controller: controller)
    }
    
}

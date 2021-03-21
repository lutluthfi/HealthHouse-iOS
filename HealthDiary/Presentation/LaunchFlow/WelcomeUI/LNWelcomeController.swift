//
//  LNWelcomeController.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 20/03/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: LNWelcomeController
final class LNWelcomeController: UIViewController {

    // MARK: DI Variable
    lazy var _view: LNWelcomeView = {
        return DefaultLNWelcomeView()
    }()
    var viewModel: LNWelcomeViewModel!

    // MARK: Common Variable


    // MARK: Create Function
    class func create(with viewModel: LNWelcomeViewModel) -> LNWelcomeController {
        let controller = LNWelcomeController()
        controller.viewModel = viewModel
        return controller
    }

    // MARK: UIViewController Function
    override func loadView() {
        self.view = (self._view as! UIView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewDidLoad()
        self.bind(to: self.viewModel)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupViewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setupViewWillDisappear()
    }

    // MARK: Bind ViewModel Function
    private func bind(to viewModel: LNWelcomeViewModel) {
    }

    // MARK: SetupView By Lifecycle Function
    func setupViewDidLoad() {
    }
    
    func setupViewWillAppear() {
        self._view.viewWillAppear(navigationController: self.navigationController,
                                  tabBarController: self.tabBarController)
    }
    
    func setupViewDidAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self._view.showContinueButton()
        }
    }
    
    func setupViewWillDisappear() {
        self._view.viewWillDisappear()
    }
    
}

// MARK: Observe ViewModel Function
extension LNWelcomeController {
    
}

// MARK: LNWelcomeViewDelegate
extension LNWelcomeController: LNWelcomeViewDelegate {

}

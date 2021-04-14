//
//  LNPadController.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: LNPadController
final class LNPadController: UITabBarController {

    // MARK: DI Variable
    lazy var _view: LNPadView = {
        return DefaultLNPadView()
    }()
    var viewModel: LNPadViewModel!

    // MARK: Common Variable


    // MARK: Create Function
    class func create(with viewModel: LNPadViewModel) -> LNPadController {
        let controller = LNPadController()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setupViewWillDisappear()
    }

    // MARK: Bind ViewModel Function
    private func bind(to viewModel: LNPadViewModel) {
    }

    // MARK: SetupView By Lifecycle Function
    private func setupViewDidLoad() {
    }
    
    private func setupViewWillAppear() {
        self._view.viewWillAppear(navigationBar: self.navigationController?.navigationBar,
                                  navigationItem: self.navigationItem,
                                  tabBarController: self.tabBarController)
    }
    
    private func setupViewWillDisappear() {
        self._view.viewWillDisappear()
    }
    
}

// MARK: Observe ViewModel Function
extension LNPadController {
    
}

// MARK: LNPadViewDelegate
extension LNPadController: LNPadViewDelegate {

}

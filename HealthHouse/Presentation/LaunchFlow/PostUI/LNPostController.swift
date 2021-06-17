//
//  LNPostController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: LNPostController
final class LNPostController: UIViewController {

    // MARK: DI Variable
    lazy var _view: LNPostView = DefaultLNPostView()
    var viewModel: LNPostViewModel!

    // MARK: Common Variable


    // MARK: Create Function
    class func create(with viewModel: LNPostViewModel) -> LNPostController {
        let vc = LNPostController()
        vc.viewModel = viewModel
        return vc
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
    private func bind(to viewModel: LNPostViewModel) {
    }

    // MARK: SetupView By Lifecycle Function
    private func setupViewDidLoad() {
    }
    
    private func setupViewWillAppear() {
        self._view.viewWillAppear(navigationController: self.navigationController,
                                  tabBarController: self.tabBarController)
    }
    
    private func setupViewWillDisappear() {
        self._view.viewWillDisappear()
    }
    
}

// MARK: Observe ViewModel Function
extension LNPostController {
    
}

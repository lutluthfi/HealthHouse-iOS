//
//  LNPostController.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//  Copyright (c) 2021 All rights reserved.
//
//  Template:
//  Modified by Arif Luthfiansyah
//  Created by Oleh Kudinov

import UIKit

// MARK: LNPostController
final class LNPostController: UIViewController {

    // MARK: DI Variable
    lazy var _view: LNPostView = {
        return DefaultLNPostView(navigationBar: self.navigationController?.navigationBar,
                                 navigationItem: self.navigationItem)
    }()
    var viewModel: LNPostViewModel!

    // MARK: Common Variable


    // MARK: Create Function
    class func create(with viewModel: LNPostViewModel) -> LNPostController {
        let vc = LNPostController()
        vc.viewModel = viewModel
        return vc
    }

    // MARK: UIViewController Function
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
        self.view = (self._view as! UIView)
    }
    
    private func setupViewWillAppear() {
        self._view.viewWillAppear()
    }
    
    private func setupViewWillDisappear() {
        self._view.viewWillDisappear()
    }
    
}

// MARK: Observe ViewModel Function
extension LNPostController {
    
}

// MARK: LNPostViewDelegate
extension LNPostController: LNPostViewDelegate {

}

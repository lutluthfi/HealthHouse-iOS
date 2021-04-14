//
//  LNWelcomeController.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 20/03/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxSwift
import UIKit

// MARK: LNWelcomeController
final class LNWelcomeController: UIViewController {

    // MARK: DI Variable
    lazy var _view: LNWelcomeView = DefaultLNWelcomeView()
    var viewModel: LNWelcomeViewModel!
    let disposeBag = DisposeBag()

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
        self.bind(to: self._view)
        self.bind(to: self.viewModel)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._view.viewWillAppear(navigationBar: self.navigationController?.navigationBar,
                                  navigationItem: self.navigationItem,
                                  tabBarController: self.tabBarController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self._view.showContinueButton { _ in }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._view.viewWillDisappear()
    }

    // MARK: Subscribe View Function
    private func bind(to view: LNWelcomeView) {
        self.subscribeContinueButtonBindTap(view.continueButton)
    }
    
    // MARK: Subscribe ViewModel Function
    private func bind(to viewModel: LNWelcomeViewModel) {
    }
    
}

// MARK: Observe ViewModel Function
extension LNWelcomeController {
    
    func subscribeContinueButtonBindTap(_ button: UIButton) {
        button.rx.tap.bind(onNext: { [unowned self] in
            self.viewModel.doContinue()
        })
        .disposed(by: self.disposeBag)
    }
    
}

//
//  LNWelcomeController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/03/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxSwift
import UIKit

// MARK: LNWelcomeController
final class LNWelcomeController: UIViewController {
    
    // MARK: DI Variable
    lazy var disposeBag = DisposeBag()
    lazy var welcomeView: LNWelcomeView = DefaultLNWelcomeView()
    var viewModel: LNWelcomeViewModel!
    lazy var _view: UIView = (self.welcomeView as! UIView)
    
    // MARK: Common Variable
    
    
    // MARK: Create Function
    class func create(with viewModel: LNWelcomeViewModel) -> LNWelcomeController {
        let controller = LNWelcomeController()
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: UIViewController Function
    override func loadView() {
        self.view = self._view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindContinueButtonBindTap(button: self.welcomeView.continueButton)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.welcomeView.viewWillAppear(navigationBar: self.navigationController?.navigationBar,
                                        navigationItem: self.navigationItem,
                                        tabBarController: self.tabBarController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.welcomeView.showContinueButton { _ in }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.welcomeView.viewWillDisappear()
    }
    
}

// MARK: BindContinueButtonBindTap
extension LNWelcomeController {
    
    func bindContinueButtonBindTap(button: UIButton) {
        button.rx
            .tap
            .bind(onNext: { [unowned self] in
                self.viewModel.willShowLNPadUI()
            })
            .disposed(by: self.disposeBag)
    }
    
}

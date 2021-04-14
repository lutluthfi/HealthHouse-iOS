//
//  HDTimelineController.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: HDTimelineController
public final class HDTimelineController: UIViewController {

    // MARK: DI Variable
    lazy var _view: HDTimelineView = {
        return DefaultHDTimelineView()
    }()
    var viewModel: HDTimelineViewModel!

    // MARK: Common Variable


    // MARK: Create Function
    class func create(with viewModel: HDTimelineViewModel) -> HDTimelineController {
        let controller = HDTimelineController()
        controller.viewModel = viewModel
        return controller
    }

    // MARK: UIViewController Function
    public override func loadView() {
        self.view = (self._view as! UIView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewDidLoad()
        self.bind(to: self.viewModel)
        self.viewModel.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewWillAppear()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setupViewWillDisappear()
    }

    // MARK: Bind ViewModel Function
    private func bind(to viewModel: HDTimelineViewModel) {
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
extension HDTimelineController {
    
}

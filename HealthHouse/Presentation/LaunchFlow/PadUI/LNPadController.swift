//
//  LNPadController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxSwift
import UIKit

// MARK: LNPadController
final class LNPadController: UITabBarController {

    // MARK: DI Variable
    let disposeBag = DisposeBag()
    lazy var padView: LNPadView = DefaultLNPadView()
    var viewModel: LNPadViewModel!
    lazy var _view: UIView = (self.padView as! UIView)

    // MARK: Common Variable

    // MARK: Create Function
    class func create(with viewModel: LNPadViewModel) -> LNPadController {
        let controller = LNPadController()
        controller.viewModel = viewModel
        return controller
    }

    // MARK: UIViewController Function
    // Unused the following code due to use UITabBarController
    // override func loadView() {
    //     self.view = (self._view as! UIView)
    // }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.padView.viewDidLoad(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindControllersViewModelToViewControllers(controllers: self.viewModel.controllers)
        self.padView.viewWillAppear(view: self.view,
                                    navigationBar: self.navigationController?.navigationBar,
                                    navigationItem: self.navigationItem,
                                    tabBarController: self.tabBarController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.padView.viewDidAppear(view: self.view)
        self.viewModel.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.padView.viewWillDisappear()
    }
    
}

// MARK: BindControllersViewModelToViewControllers
extension LNPadController {
    
    func bindControllersViewModelToViewControllers(controllers: Observable<LNPadViewModelRequest.Controllers>) {
        controllers
            .subscribe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [unowned self] (controllers) in
                let pfPreviewController = controllers.pfPreviewController
                let hdTimelineController = controllers.hdTimelineController
                let personFillImage = UIImage(systemName: "person.fill")
                let heartTextSquareFillImage = UIImage(systemName: "heart.text.square.fill")
                pfPreviewController.tabBarItem = UITabBarItem(title: "Profile",
                                                              image: personFillImage,
                                                              selectedImage: personFillImage)
                hdTimelineController.tabBarItem = UITabBarItem(title: "Health Diary",
                                                               image: heartTextSquareFillImage,
                                                               selectedImage: heartTextSquareFillImage)
                let _controllers = [hdTimelineController, pfPreviewController]
                self.viewControllers = _controllers.map {
                    let navController = UINavigationController(rootViewController: $0)
                    navController.hidesBottomBarWhenPushed = false
                    return navController
                }
            })
            .disposed(by: self.disposeBag)
    }
    
}

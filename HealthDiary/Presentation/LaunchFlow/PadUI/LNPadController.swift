//
//  LNPadController.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxSwift
import UIKit

// MARK: LNPadController
final class LNPadController: UITabBarController {

    // MARK: DI Variable
    lazy var _view: LNPadView = DefaultLNPadView()
    var viewModel: LNPadViewModel!
    let disposeBag = DisposeBag()

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
        self._view.viewDidLoad(self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._view.viewWillAppear(navigationBar: self.navigationController?.navigationBar,
                                  navigationItem: self.navigationItem,
                                  tabBarController: self.tabBarController)
        self.subscribeControllersViewModel(self.viewModel.controllers)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._view.viewWillDisappear()
    }
    
}

// MARK: Observe ViewModel Function
extension LNPadController {
    
    func subscribeControllersViewModel(_ controllers: Observable<LNPadViewModelRequestValue.Controllers>) {
        controllers.subscribe(onNext: { [unowned self] controllers in
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

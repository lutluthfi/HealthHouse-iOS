//
//  LNPadController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import HealthKit
import RxCocoa
import RxSwift
import UIKit

// MARK: LNPadController
final class LNPadController: UITabBarController {

    // MARK: DI Variable
    let disposeBag = DisposeBag()
    lazy var _view: LNPadView = DefaultLNPadView()
    var viewModel: LNPadViewModel!

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
        self._view.viewDidLoad(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bind(viewModelControllers: self.viewModel.controllers)
        self.viewModel
            .pfPersonalizeUIDidDismiss
            .bind(onNext: { [unowned self] in
                self.selectedIndex = 0
            })
            .disposed(by: self.disposeBag)
        self._view.viewWillAppear(view: self.view,
                                    navigationController: self.navigationController,
                                    navigationItem: self.navigationItem,
                                    tabBarController: self.tabBarController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self._view.viewDidAppear(view: self.view)
        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
              let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
              let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
              let height = HKObjectType.quantityType(forIdentifier: .height),
              let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
              let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }
        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                        activeEnergy,
                                                        HKObjectType.workoutType()]
        
        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                       bloodType,
                                                       biologicalSex,
                                                       bodyMassIndex,
                                                       height,
                                                       bodyMass,
                                                       HKObjectType.workoutType()]
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { authorized, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if authorized {
                print("Authorized")
            } else {
                print("Not authorized")
            }
        }
        self.viewModel.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._view.viewWillDisappear()
    }
    
}

// MARK: BindControllersViewModelToViewControllers
extension LNPadController {
    
    func bind(viewModelControllers controllers: Observable<LNPadViewModelRequest.Controllers>) {
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

extension LNPadController {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Profile" {
            self.viewModel.profileTabBarDidSelect()
        }
    }
    
}

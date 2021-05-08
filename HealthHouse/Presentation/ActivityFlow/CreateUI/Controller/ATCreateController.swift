//
//  ATCreateController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 23/04/21.
//  Copyright (c) 2021 All rights reserved.

import MapKit
import RxCocoa
import RxDataSources
import RxGesture
import RxKeyboard
import RxSwift
import UIKit

// MARK: ATCreateController
final class ATCreateController: UITableViewController {

    // MARK: DI Variable
    lazy var createView: ATCreateView = DefaultATCreateView()
    let disposeBag = DisposeBag()
    let locationManager = CLLocationManager()
    var viewModel: ATCreateViewModel!

    // MARK: Common Variable
    var isSelectDate = false
    var isSelectTime = false
    let _title = BehaviorRelay<String?>(value: nil)
    let _date = BehaviorRelay<Date>(value: Date())
    let _practitioner = BehaviorRelay<String?>(value: nil)
    let _location = BehaviorRelay<MKMapItem?>(value: nil)
    let _time = BehaviorRelay<Date>(value: Date())

    // MARK: Create Function
    class func create(with viewModel: ATCreateViewModel) -> ATCreateController {
        let controller = ATCreateController()
        controller.viewModel = viewModel
        return controller
    }

    // MARK: UIViewController Function
     override func loadView() {
        self.view = self.createView.tableView
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindTableViewDelegate(tableView: self.tableView)
        self.bindFieldsToTableView(relay: self.createView.fields, tableView: self.tableView)
        self.viewModel.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createView.viewWillAppear(navigationController: self.navigationController,
                                       navigationItem: self.navigationItem,
                                       tabBarController: self.tabBarController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.createView.viewWillDisappear()
    }
    
}

// MARK: BindDatePickerToDateOrTime
extension ATCreateController {
    
    func bindDatePickerToDateOrTime(picker: UIDatePicker, relay: BehaviorRelay<Date>) {
        relay
            .asDriver()
            .drive(picker.rx.date)
            .disposed(by: self.disposeBag)
        picker.rx
            .date
            .asDriver()
            .drive(relay)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindDateToDateLabel
extension ATCreateController {
    
    func bindDateToDateLabel(relay: BehaviorRelay<Date>, label: UILabel) {
        let formats: [Date.FormatterComponent] = [.dayOfWeekWideName,
                                                  .comma,
                                                  .whitespace,
                                                  .monthOfYearShorthandName,
                                                  .whitespace,
                                                  .dayOfMonth,
                                                  .comma,
                                                  .whitespace,
                                                  .yearFullDigits]
        relay
            .asDriver()
            .map({ $0.formatted(components: formats) })
            .drive(label.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: LocationAuthorizationStatusDidHandle
extension ATCreateController {
    
    func locationAuthorizationStatusDidHandle(_ locationManager: CLLocationManager,
                                              status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.viewModel.presentSearchUI()
        case .denied, .restricted:
            self.showAlertWhenLocationServiceNotAvailable()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError("Could not recognized \(CLLocationManager.authorizationStatus().rawValue)")
        }
    }
    
}

// MARK: ShowAlertWhenLocationServiceNotAvailable
extension ATCreateController {
    
    func showAlertWhenLocationServiceNotAvailable() {
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        let openSettingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (action) in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        }
        self.showAlert(title: "Attention ⚠️",
                       message: "\(AppConfiguration.appName) needs to access your location to enhanced our location feature",
                       actions: [dismissAction, openSettingsAction])
    }
    
}

// MARK: BindSelectedLocationViewModelToLocationLabel
extension ATCreateController {
    
    func bindSelectedLocationViewModelToLocationLabel(relay: PublishRelay<MKMapItem>, label: UILabel) {
        relay
            .subscribe(on: MainScheduler.instance)
            .map({ $0.name })
            .bind(to: label.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTimeToTimeLabel
extension ATCreateController {
    
    func bindTimeToTimeLabel(relay: BehaviorRelay<Date>, label: UILabel) {
        let formats: [Date.FormatterComponent] = [.hour12Padding, .colon, .minutePadding, .whitespace, .meridiem]
        relay
            .asDriver()
            .map({ $0.formatted(components: formats) })
            .drive(label.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

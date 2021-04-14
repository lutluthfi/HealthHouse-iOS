//
//  PFPersonalizeView.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: PFPersonalizeViewFunction
protocol PFPersonalizeViewFunction {
    func viewWillAppear(navigationController: UINavigationController?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: PFPersonalizeViewSubview
protocol PFPersonalizeViewSubview {
    var countryDialignCodePicker: UIPickerView { get }
    var createBarButtonItem: UIBarButtonItem { get }
    var dateOfBirthPicker: UIDatePicker { get }
    var genderPicker: UIPickerView { get }
    var tableView: UITableView { get }
}

// MARK: PFPersonalizeViewVariable
protocol PFPersonalizeViewVariable {
    var personalizeFields: [[PFPersonalizeFieldDomain]] { get }
}

// MARK: PFPersonalizeView
protocol PFPersonalizeView: PFPersonalizeViewFunction, PFPersonalizeViewSubview, PFPersonalizeViewVariable { }

// MARK: DefaultPFPersonalizeView
final class DefaultPFPersonalizeView: UIView, PFPersonalizeView {

    // MARK: PFPersonalizeViewSubview
    lazy var countryDialignCodePicker = UIPickerView()
    lazy var createBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: nil)
    lazy var dateOfBirthPicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()
    lazy var genderPicker = UIPickerView()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = CGFloat(44)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    // MARK: PFPersonalizeViewVariable
    let personalizeFields: [[PFPersonalizeFieldDomain]] = [[.photo],
                                                           [.firstName, .lastName],
                                                           [.dateOfBirth],
                                                           [.gender],
                                                           [.mobileNumber]]
    
    // MARK: Init Function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: UIScreen.main.fixedCoordinateSpace.bounds)
        self.subviewWillAdd()
        self.subviewConstraintWillMake()
        self.viewDidInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviewDidLayout()
    }
    
}

// MARK: Internal Function
extension DefaultPFPersonalizeView {
    
    func subviewDidLayout() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func subviewWillAdd() {
        self.addSubview(self.tableView)
    }
    
    func subviewConstraintWillMake() {
    }
    
    func viewDidInit() {
    }
    
}

// MARK: PFPersonalizeViewFunction
extension DefaultPFPersonalizeView {
    
    func viewWillAppear(navigationController: UINavigationController?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
        guaranteeMainThread {
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationItem.hidesBackButton = true
            navigationItem.rightBarButtonItems = [self.createBarButtonItem]
        }
    }
    
    func viewWillDisappear() {
        
    }
    
}

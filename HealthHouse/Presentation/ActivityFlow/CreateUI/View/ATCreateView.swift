//
//  ATCreateView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 23/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxSwift
import UIKit

// MARK: ATCreateViewFunction
protocol ATCreateViewFunction {
    func viewWillAppear(navigationController: UINavigationController?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: ATCreateViewSubview
protocol ATCreateViewSubview {
    var createBarButtonItem: UIBarButtonItem { get }
    var tableView: UITableView { get }
}

// MARK: ATCreateViewVariable
protocol ATCreateViewVariable {
    var sections: BehaviorRelay<[SectionDomain<RowDomain>]> { get }
}

// MARK: ATCreateView
protocol ATCreateView: ATCreateViewFunction, ATCreateViewSubview, ATCreateViewVariable { }

// MARK: DefaultATCreateView
final class DefaultATCreateView: UIView, ATCreateView {
    
    // MARK: ATCreateViewSubview
    lazy var createBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: nil)
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.fixedCoordinateSpace.bounds, style: .insetGrouped)
        tableView.allowsSelection = true
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = HHTextFieldTableCell.height
        return tableView
    }()
    
    // MARK: ATCreateViewVariable
    let sections = BehaviorRelay<[SectionDomain<RowDomain>]>(value: [SectionDomain(header: "Title", items: [.title]),
                                                                     SectionDomain(header: "Date and Time", items: [.date, .time]),
                                                                     SectionDomain(header: "Health Practition", items: [.practitioner, .location]),
                                                                     SectionDomain(header: "Attachment", items: [.attachment]),
                                                                     SectionDomain(header: "Flag", items: [.flag]),
                                                                     SectionDomain(header: "Explanation", items: [.explanation])])
    
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
extension DefaultATCreateView {
    
    func subviewWillAdd() {
        self.addSubview(self.tableView)
    }
    
    func subviewConstraintWillMake() {
    }
    
    func subviewDidLayout() {
        self.tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    func viewDidInit() {
    }
    
}

// MARK: ATCreateViewFunction
extension DefaultATCreateView {
    
    func viewWillAppear(navigationController: UINavigationController?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
        navigationItem.title = "Create Activity"
        guard let _navigationController = navigationController else { return }
        _navigationController.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = self.createBarButtonItem
    }
    
    func viewWillDisappear() {
        
    }
    
}

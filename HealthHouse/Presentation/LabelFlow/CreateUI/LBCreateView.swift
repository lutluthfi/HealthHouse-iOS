//
//  LBCreateView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

// MARK: LBCreateViewFunction
protocol LBCreateViewFunction {
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: LBCreateViewSubview
protocol LBCreateViewSubview {
    var createBarButtonItem: UIBarButtonItem { get }
    var tableView: UITableView { get }
}

// MARK: LBCreateViewVariable
protocol LBCreateViewVariable {
    var sections: BehaviorRelay<[SectionDomain<RowDomain>]> { get }
}

// MARK: LBCreateView
protocol LBCreateView: LBCreateViewFunction, LBCreateViewSubview, LBCreateViewVariable { }

// MARK: DefaultLBCreateView
final class DefaultLBCreateView: UIView, LBCreateView {

    // MARK: LBCreateViewSubview
    lazy var createBarButtonItem = UIBarButtonItem(title: "Create",
                                                   style: .done,
                                                   target: self,
                                                   action: nil)
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.fixedCoordinateSpace.bounds, style: .grouped)
        tableView.rowHeight = CGFloat(44)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    // MARK: LBCreateViewVariable
    lazy var sections = BehaviorRelay<[SectionDomain<RowDomain>]>(value: [SectionDomain(footer: "The new label must be unique. Respresents a collection of activities that have been or will be created to make it easier for you to filter activities.",
                                                                                        header: "Title",
                                                                                        items: [.title])])
    
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
extension DefaultLBCreateView {
    
    func subviewWillAdd() {
    }
    
    func subviewConstraintWillMake() {
    }
    
    func subviewDidLayout() {
    }
    
    func viewDidInit() {
    }
    
}

// MARK: LBCreateViewFunction
extension DefaultLBCreateView {
    
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
        navigationItem.title = "New Label"
        navigationItem.rightBarButtonItem = self.createBarButtonItem
    }
    
    func viewWillDisappear() {
        
    }
    
}

//
//  LBListView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/05/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: LBListViewFunction
protocol LBListViewFunction {
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: LBListViewSubview
protocol LBListViewSubview {
    var doneBarButtonItem: UIBarButtonItem { get }
    var tableView: UITableView { get }
}

// MARK: LBListViewVariable
protocol LBListViewVariable {
}

// MARK: LBListView
protocol LBListView: LBListViewFunction, LBListViewSubview, LBListViewVariable { }

// MARK: DefaultLBListView
final class DefaultLBListView: UIView, LBListView {

    // MARK: LBListViewSubview
    lazy var doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.fixedCoordinateSpace.bounds, style: .grouped)
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        return tableView
    }()

    // MARK: LBListViewVariable
    
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
extension DefaultLBListView {
    
    func subviewWillAdd() {
    }
    
    func subviewConstraintWillMake() {
    }
    
    func subviewDidLayout() {
    }
    
    func viewDidInit() {
    }
    
}

// MARK: LBListViewFunction
extension DefaultLBListView {
    
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
        navigationItem.rightBarButtonItem = self.doneBarButtonItem
    }
    
    func viewWillDisappear() {
        
    }
    
}

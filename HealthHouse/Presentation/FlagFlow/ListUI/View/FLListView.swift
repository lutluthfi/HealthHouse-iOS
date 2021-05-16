//
//  FLListView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/05/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: FLListViewFunction
protocol FLListViewFunction {
    func viewWillAppear(navigationController: UINavigationController?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?,
                        toolbarItems: inout [UIBarButtonItem]?)
    func viewWillDisappear()
}

// MARK: FLListViewSubview
protocol FLListViewSubview {
    var createBarButtonItem: UIBarButtonItem { get }
    var doneBarButtonItem: UIBarButtonItem { get }
    var selectedCountBarButtonItem: UIBarButtonItem { get }
    var tableView: UITableView { get }
}

// MARK: FLListViewVariable
protocol FLListViewVariable {
    var asView: UIView { get }
}

// MARK: FLListView
protocol FLListView: FLListViewFunction, FLListViewSubview, FLListViewVariable { }

// MARK: DefaultFLListView
final class DefaultFLListView: UIView, FLListView {

    // MARK: FLListViewSubview
    lazy var asView: UIView = (self as UIView)
    lazy var createBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: nil)
    lazy var doneBarButtonItem = UIBarButtonItem.done
    lazy var selectedCountBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "",
                                     style: .plain,
                                     target: self,
                                     action: nil)
        button.isEnabled = false
        button.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .footnote),
                                       .foregroundColor: UIColor.black],
                                      for: .disabled)
        return button
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.fixedCoordinateSpace.bounds, style: .grouped)
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        return tableView
    }()

    // MARK: FLListViewVariable
    
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
extension DefaultFLListView {
    
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
extension DefaultFLListView {
    
    func viewWillAppear(navigationController: UINavigationController?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?,
                        toolbarItems: inout [UIBarButtonItem]?) {
        navigationController?.isToolbarHidden = false
        navigationItem.title = "Flag"
        navigationItem.leftBarButtonItem = self.createBarButtonItem
        navigationItem.rightBarButtonItem = self.doneBarButtonItem
        toolbarItems = [.flexible, self.selectedCountBarButtonItem, .flexible]
    }
    
    func viewWillDisappear() {
        
    }
    
}

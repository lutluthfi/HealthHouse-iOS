//
//  LCSearchView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/04/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: LCSearchViewFunction
protocol LCSearchViewFunction {
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: LCSearchViewSubview
protocol LCSearchViewSubview {
    var tableView: UITableView { get }
}

// MARK: LCSearchViewVariable
protocol LCSearchViewVariable {
}

// MARK: LCSearchView
protocol LCSearchView: LCSearchViewFunction, LCSearchViewSubview, LCSearchViewVariable { }

// MARK: DefaultLCSearchView
final class DefaultLCSearchView: UIView, LCSearchView {

    // MARK: LCSearchViewSubview
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.frame, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    // MARK: LCSearchViewVariable
    
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
extension DefaultLCSearchView {
    
    func subviewWillAdd() {
        self.addSubview(self.tableView)
    }
    
    func subviewConstraintWillMake() {
    }
    
    func subviewDidLayout() {
        self.tableView.contentInset = UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 0)
        self.tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func viewDidInit() {
    }
    
}

// MARK: LCSearchViewFunction
extension DefaultLCSearchView {
    
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
    }
    
    func viewWillDisappear() {
        
    }
    
}

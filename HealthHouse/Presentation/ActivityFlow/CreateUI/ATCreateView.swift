//
//  ATCreateView.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 23/04/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: ATCreateViewDelegate
protocol ATCreateViewDelegate: AnyObject {
    
}

// MARK: ATCreateViewFunction
protocol ATCreateViewFunction {
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: ATCreateViewSubview
protocol ATCreateViewSubview {
}

// MARK: ATCreateViewVariable
protocol ATCreateViewVariable {
    var delegate: ATCreateViewDelegate? { get }
}

// MARK: ATCreateView
protocol ATCreateView: ATCreateViewFunction, ATCreateViewSubview, ATCreateViewVariable { }

// MARK: DefaultATCreateView
final class DefaultATCreateView: UIView, ATCreateView {

    // MARK: ATCreateViewSubview

    // MARK: ATCreateViewVariable
    weak var delegate: ATCreateViewDelegate?
    
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
    }
    
    func subviewConstraintWillMake() {
    }
    
    func subviewDidLayout() {
    }
    
    func viewDidInit() {
    }
    
}

// MARK: ATCreateViewFunction
extension DefaultATCreateView {
    
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
    }
    
    func viewWillDisappear() {
        
    }
    
}

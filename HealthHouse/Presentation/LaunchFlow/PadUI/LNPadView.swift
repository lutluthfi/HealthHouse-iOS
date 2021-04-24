//
//  LNPadView.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: LNPadViewFunction
protocol LNPadViewFunction {
    func viewDidLoad(view: UIView)
    func viewWillAppear(view: UIView,
                        navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?)
    func viewDidAppear(view: UIView)
    func viewWillDisappear()
}

// MARK: LNPadViewSubview
protocol LNPadViewSubview {
}

// MARK: LNPadViewVariable
protocol LNPadViewVariable {
}

// MARK: LNPadView
protocol LNPadView: LNPadViewFunction, LNPadViewSubview, LNPadViewVariable { }

// MARK: DefaultLNPadView
final class DefaultLNPadView: LNPadView {

    // MARK: LNPadViewSubview

    // MARK: LNPadViewVariable

}

// MARK: Internal Function
extension DefaultLNPadView {
    
    func subviewDidLayout() {
        // do nothing
    }
    
    func subviewWillAdd() {
        // do nothing
    }
    
    func subviewConstraintWillMake() {
        // do nothing
    }
    
    func viewDidInit() {
        // do nothing
    }
    
}

// MARK: LNPadViewFunction
extension DefaultLNPadView {
    
    func viewDidLoad(view: UIView) {
        view.backgroundColor = .white
        view.showLoadingIndicator()
    }
    
    func viewWillAppear(view: UIView,
                        navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
        // do nothing
    }
    
    func viewDidAppear(view: UIView) {
        view.hideLoadingIndicator()
    }
    
    func viewWillDisappear() {
        // do nothing
    }
    
}

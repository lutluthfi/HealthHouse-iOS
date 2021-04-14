//
//  LNPadView.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: LNPadViewFunction
protocol LNPadViewFunction {
    func viewDidLoad(_ view: UIView)
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?)
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
    
    func viewDidLoad(_ view: UIView) {
        view.backgroundColor = .white
    }
    
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
        // do nothing
    }
    
    func viewWillDisappear() {
        // do nothing
    }
    
}

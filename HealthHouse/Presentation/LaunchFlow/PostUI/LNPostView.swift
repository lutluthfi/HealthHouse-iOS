//
//  LNPostView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: LNPostViewFunction
protocol LNPostViewFunction {
    func viewWillAppear(navigationController: UINavigationController?, tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: LNPostViewSubview
protocol LNPostViewSubview {
}

// MARK: LNPostViewVariable
protocol LNPostViewVariable {
}

// MARK: LNPostView
protocol LNPostView: LNPostViewFunction, LNPostViewSubview, LNPostViewVariable { }

// MARK: DefaultLNPostView
final class DefaultLNPostView: UIView, LNPostView {

    // MARK: Subview Variable

    // MARK: DI Variable
    
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
extension DefaultLNPostView {
    
    func subviewDidLayout() {
        
    }
    
    func subviewWillAdd() {
    }
    
    func subviewConstraintWillMake() {
    }
    
    func viewDidInit() {
        
    }
    
}

// MARK: Input Function
extension DefaultLNPostView {
    
    func viewWillAppear(navigationController: UINavigationController?, tabBarController: UITabBarController?) {
        
    }
    
    func viewWillDisappear() {
        
    }
    
}

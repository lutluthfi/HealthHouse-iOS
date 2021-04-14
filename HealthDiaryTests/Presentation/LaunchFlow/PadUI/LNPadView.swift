//
//  LNPadView.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: LNPadViewDelegate
protocol LNPadViewDelegate: AnyObject {
    
}

// MARK: LNPadViewFunction
protocol LNPadViewFunction {
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
    var delegate: LNPadViewDelegate? { get }
}

// MARK: LNPadView
protocol LNPadView: LNPadViewFunction, LNPadViewSubview, LNPadViewVariable { }

// MARK: DefaultLNPadView
final class DefaultLNPadView: UIView, LNPadView {

    // MARK: LNPadViewSubview

    // MARK: LNPadViewVariable
    weak var delegate: LNPadViewDelegate?
    
    // MARK: Init Function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: UIScreen.main.fixedCoordinateSpace.bounds)
        self.subviewWillAdd()
        self.viewDidInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviewConstraintWillMake()
    }

}

// MARK: Internal Function
extension DefaultLNPadView {
    
    func subviewWillAdd() {
    }
    
    func subviewConstraintWillMake() {
    }
    
    func viewDidInit() {
        
    }
    
}

// MARK: LNPadViewFunction
extension DefaultLNPadView {
    
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
        
    }
    
    func viewWillDisappear() {
        
    }
    
}

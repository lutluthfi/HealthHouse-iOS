//
//  PFPreviewView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: PFPreviewViewFunction
protocol PFPreviewViewFunction {
    func viewWillAppear(navigationController: UINavigationController?, tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: PFPreviewViewSubview
protocol PFPreviewViewSubview {
}

// MARK: PFPreviewViewVariable
protocol PFPreviewViewVariable {
}

// MARK: PFPreviewView
protocol PFPreviewView: PFPreviewViewFunction, PFPreviewViewSubview, PFPreviewViewVariable { }

// MARK: DefaultPFPreviewView
final class DefaultPFPreviewView: UIView, PFPreviewView {

    // MARK: PFPreviewViewSubview

    // MARK: PFPreviewViewVariable
    
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
extension DefaultPFPreviewView {
    
    func subviewDidLayout() {
        
    }
    
    func subviewWillAdd() {
    }
    
    func subviewConstraintWillMake() {
    }
    
    func viewDidInit() {
        
    }
    
}

// MARK: PFPreviewViewFunction
extension DefaultPFPreviewView {
    
    func viewWillAppear(navigationController: UINavigationController?, tabBarController: UITabBarController?) {
        
    }
    
    func viewWillDisappear() {
        
    }
    
}

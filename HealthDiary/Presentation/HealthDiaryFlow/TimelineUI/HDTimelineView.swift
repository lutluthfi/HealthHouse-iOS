//
//  HDTimelineView.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: HDTimelineViewFunction
protocol HDTimelineViewFunction {
    func viewWillAppear(navigationController: UINavigationController?, tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: HDTimelineViewSubview
protocol HDTimelineViewSubview {
}

// MARK: HDTimelineViewVariable
protocol HDTimelineViewVariable {
}

// MARK: HDTimelineView
protocol HDTimelineView: HDTimelineViewFunction, HDTimelineViewSubview, HDTimelineViewVariable { }

// MARK: DefaultHDTimelineView
final class DefaultHDTimelineView: UIView, HDTimelineView {

    // MARK: HDTimelineViewSubview

    // MARK: HDTimelineViewVariable
    
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
extension DefaultHDTimelineView {
    
    func subviewDidLayout() {
        
    }
    
    func subviewWillAdd() {
    }
    
    func subviewConstraintWillMake() {
    }
    
    func viewDidInit() {
        
    }
    
}

// MARK: HDTimelineViewFunction
extension DefaultHDTimelineView {
    
    func viewWillAppear(navigationController: UINavigationController?, tabBarController: UITabBarController?) {
        
    }
    
    func viewWillDisappear() {
        
    }
    
}

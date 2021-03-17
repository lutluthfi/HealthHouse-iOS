//
//  LNPostView.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//  Copyright (c) 2021 All rights reserved.
//
//  Template:
//  Modified by Arif Luthfiansyah
//  Created by Oleh Kudinov

import UIKit

// MARK: LNPostViewDelegate
protocol LNPostViewDelegate: AnyObject {
    
}

// MARK: LNPostViewFunction
protocol LNPostViewFunction {
    func viewWillAppear()
    func viewWillDisappear()
}

// MARK: LNPostViewSubview
protocol LNPostViewSubview {
    var navigationBar: UINavigationBar? { get }
    var navigationItem: UINavigationItem! { get }
}

// MARK: LNPostViewVariable
protocol LNPostViewVariable {
    var delegate: LNPostViewDelegate? { get set }
}

// MARK: LNPostView
protocol LNPostView: LNPostViewFunction, LNPostViewSubview, LNPostViewVariable { }

// MARK: DefaultLNPostView
final class DefaultLNPostView: UIView, LNPostView {

    // MARK: Subview Variable
    weak var navigationBar: UINavigationBar?
    weak var navigationItem: UINavigationItem!

    // MARK: DI Variable
    weak var delegate: LNPostViewDelegate?
    
    // MARK: Init Function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(navigationBar: UINavigationBar?, navigationItem: UINavigationItem) {
        self.navigationBar = navigationBar
        self.navigationItem = navigationItem
        super.init(frame: UIScreen.main.fixedCoordinateSpace.bounds)
        self.addSubviews()
        self.makeConstraints()
    }

}

// MARK: Internal Function
extension DefaultLNPostView {
    
    func addSubviews() {
    }
    
    func makeConstraints() {
    }
    
}

// MARK: Input Function
extension DefaultLNPostView {
    
    func viewWillAppear() {
        
    }
    
    func viewWillDisappear() {
        
    }
    
}

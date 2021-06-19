//
//  LNOnBoardingView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/06/21.
//  Copyright (c) 2021 All rights reserved.
//

import UIKit

// MARK: LNOnBoardingViewFunction
protocol LNOnBoardingViewFunction {
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: LNOnBoardingViewSubview
protocol LNOnBoardingViewSubview {
    var collectionView: UICollectionView { get }
}

// MARK: LNOnBoardingViewVariable
protocol LNOnBoardingViewVariable {
    var asView: UIView { get }
    var walkthroughImageNames: [String] { get }
}

// MARK: LNOnBoardingView
protocol LNOnBoardingView: LNOnBoardingViewFunction, LNOnBoardingViewSubview, LNOnBoardingViewVariable { }

// MARK: DefaultLNOnBoardingView
final class DefaultLNOnBoardingView: UIView, LNOnBoardingView {

    // MARK: LNOnBoardingViewSubview
    lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = UIScreen.main.fixedCoordinateSpace.bounds.size
        let collectionView = UICollectionView(frame: UIScreen.main.fixedCoordinateSpace.bounds,
                                              collectionViewLayout: collectionViewLayout)
        return collectionView
    }()

    // MARK: LNOnBoardingViewVariable
    lazy var asView: UIView = (self as UIView)
    lazy var walkthroughImageNames: [String] = {
       return ["", "", ""]
    }()
    
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
extension DefaultLNOnBoardingView {
    
    func subviewWillAdd() {
        self.addSubview(self.collectionView)
    }
    
    func subviewConstraintWillMake() {
    }
    
    func subviewDidLayout() {
    }
    
    func viewDidInit() {
    }
    
}

// MARK: LNOnBoardingViewFunction
extension DefaultLNOnBoardingView {
    
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
    }
    
    func viewWillDisappear() {
        
    }
    
}

//
//  PFPreviewView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxSwift
import UIKit

// MARK: PFPreviewViewFunction
protocol PFPreviewViewFunction {
    func viewWillAppear(navigationController: UINavigationController?, tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: PFPreviewViewSubview
protocol PFPreviewViewSubview {
    var tableView: UITableView { get }
}

// MARK: PFPreviewViewVariable
protocol PFPreviewViewVariable {
    var sections: Observable<[SectionDomain<RowDomain>]> { get }
}

// MARK: PFPreviewView
protocol PFPreviewView: PFPreviewViewFunction, PFPreviewViewSubview, PFPreviewViewVariable { }

// MARK: DefaultPFPreviewView
final class DefaultPFPreviewView: UIView, PFPreviewView {

    // MARK: PFPreviewViewSubview
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.fixedCoordinateSpace.bounds, style: .grouped)
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultTableCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubtitleTableCell")
        return tableView
    }()

    // MARK: PFPreviewViewVariable
    lazy var sections: Observable<[SectionDomain<RowDomain>]> = {
        let allergyRows: [RowDomain] = []
        let allergySection = SectionDomain(footer: nil, header: "allergy", items: allergyRows)
        let nameSection = SectionDomain(footer: nil, header: "photo-with-name", items: [RowDomain.photoWithName])
        let sections = [nameSection, allergySection]
        return .just(sections)
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

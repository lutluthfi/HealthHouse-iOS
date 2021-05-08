//
//  HDTimelineView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxSwift
import UIKit

// MARK: HDTimelineViewFunction
protocol HDTimelineViewFunction {
    func viewDidLoad(navigationController: UINavigationController?,
                     tabBarController: UITabBarController?,
                     navigationItem: UINavigationItem)
    func viewWillAppear(navigationController: UINavigationController?, tabBarController: UITabBarController?)
    func viewWillDisappear()
}

// MARK: HDTimelineViewSubview
protocol HDTimelineViewSubview {
    var addBarButtonItem: UIBarButtonItem { get }
    var calendarSeparatorView: UIView { get }
    var calendarCollectionView: UICollectionView { get }
    var dayHeaderStackView: UIStackView { get }
    var timelineTableView: UITableView { get }
}

// MARK: HDTimelineViewVariable
protocol HDTimelineViewVariable {
    var HDTLActivityTableCellIdentifier: String { get }
    var calendarItems: Observable<[HDTLCalendarItemDomain]> { get }
}

// MARK: HDTimelineView
protocol HDTimelineView: HDTimelineViewFunction, HDTimelineViewSubview, HDTimelineViewVariable { }

// MARK: DefaultHDTimelineView
final class DefaultHDTimelineView: UIView, HDTimelineView {

    // MARK: HDTimelineViewSubview
    lazy var addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    lazy var calendarSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appleShadowNavigationbar
        return view
    }()
    lazy var calendarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .appleNavigationBar
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.register(HDTLCalendarItemCollectionCell.self,
                                forCellWithReuseIdentifier: HDTLCalendarItemCollectionCell.identifier)
        return collectionView
    }()
    lazy var dayHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        for day in days {
            let label = UILabel()
            label.text = day
            label.font = .preferredFont(forTextStyle: .footnote)
            label.textColor = .darkText
            label.textAlignment = .center
            label.backgroundColor = .appleNavigationBar
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    lazy var timelineTableView: UITableView = {
        let tableView = UITableView(frame: self.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        return tableView
    }()

    // MARK: HDTimelineViewVariable
    let HDTLActivityTableCellIdentifier: String = "HDTLActivityTableCell"
    let calendarItems = Observable<[HDTLCalendarItemDomain]>.create { (observer) -> Disposable in
        let calendar = Calendar.current
        let startDate = Date(timeIntervalSince1970: 0)
        let endDate = calendar.date(byAdding: .year, value: 10, to: Date())!
        let yearInterval = DateInterval(start: startDate, end: endDate)
        let dayCalendarItems = HDTLCalendarItemDomain.generateDays(inYear: yearInterval)
        observer.onNext(dayCalendarItems)
        observer.onCompleted()
        return Disposables.create()
    }
    
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
        self.calendarCollectionView.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.top.equalTo(self.dayHeaderStackView.snp.bottom)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
        }
        self.timelineTableView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.top.equalTo(self.calendarSeparatorView.snp.bottom)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func subviewWillAdd() {
        self.addSubview(self.dayHeaderStackView)
        self.addSubview(self.calendarCollectionView)
        self.addSubview(self.calendarSeparatorView)
        self.addSubview(self.timelineTableView)
    }
    
    func subviewConstraintWillMake() {
        self.dayHeaderStackView.snp.makeConstraints { (make) in
            make.height.equalTo(32)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
        }
        self.calendarSeparatorView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.top.equalTo(self.calendarCollectionView.snp.bottom)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    func viewDidInit() {
        
    }
    
}

// MARK: HDTimelineViewFunction
extension DefaultHDTimelineView {
    
    func viewDidLoad(navigationController: UINavigationController?,
                     tabBarController: UITabBarController?,
                     navigationItem: UINavigationItem) {
        guard let _navigationController = navigationController else { return }
        navigationItem.rightBarButtonItems = [self.addBarButtonItem]
        _navigationController.setNavigationBarHidden(false, animated: false)
        _navigationController.navigationBar.shadowImage = UIImage()
        _navigationController.navigationBar.barTintColor = .appleNavigationBar
    }
    
    func viewWillAppear(navigationController: UINavigationController?, tabBarController: UITabBarController?) {
    }
    
    func viewWillDisappear() {
    }
    
}

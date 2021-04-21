//
//  HDTimelineController.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: HDTimelineController
public final class HDTimelineController: UIViewController {

    // MARK: DI Variable
    let disposeBag = DisposeBag()
    lazy var timelineView: HDTimelineView = DefaultHDTimelineView()
    var viewModel: HDTimelineViewModel!
    lazy var _view: UIView = (self.timelineView as! UIView)

    // MARK: Common Variable
    let _selectedDate = BehaviorSubject<Date>(value: Date())
    var calendarItems: [HDTLCalendarItemDomain] = []

    // MARK: Create Function
    class func create(with viewModel: HDTimelineViewModel) -> HDTimelineController {
        let controller = HDTimelineController()
        controller.viewModel = viewModel
        return controller
    }

    // MARK: UIViewController Function
    public override func loadView() {
        self.timelineView
            .collectionView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        self.view = self._view
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(view: self.timelineView, viewModel: self.viewModel)
        self.timelineView.viewDidLoad(navigationController: self.navigationController,
                                      tabBarController: self.tabBarController)
        self.viewModel.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timelineView.viewWillAppear(navigationController: self.navigationController,
                                         tabBarController: self.tabBarController)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let now = Date()
        let nowFormatted = now.formatted(components: [.dayOfWeekWideName,
                                                      .comma,
                                                      .whitespace,
                                                      .dayOfMonth,
                                                      .whitespace,
                                                      .monthOfYearFullName,
                                                      .whitespace,
                                                      .yearFullDigits])
        let todayCalendarItem = HDTLCalendarItemDomain(date: now, dateFormatted: nowFormatted)
        let todayIndex = self.calendarItems.index(of: todayCalendarItem)
        guard let _todayIndex = todayIndex else { return }
        let selectedIndex = IndexPath(row: _todayIndex, section: 0)
        self.timelineView.collectionView.selectItem(at: selectedIndex,
                                                    animated: false,
                                                    scrollPosition: .centeredHorizontally)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timelineView.viewWillDisappear()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: Bind View & ViewModel Function
    private func bind(view: HDTimelineView, viewModel: HDTimelineViewModel) {
        self.bindCalendarItems(observable: view.calendarItems)
        self.bindCalendarItemsToCollectionView(observable: view.calendarItems, collectionView: view.collectionView)
        self.bindCollectionViewModelSelectedToDateDetailLabel(collectionView: view.collectionView,
                                                              label: view.dateDetailLabel)
        self.bindSelectedDateToDateDetailLabel(observable: self._selectedDate, label: view.dateDetailLabel)
    }
    
}

// MARK: BindSelectedDateToDateDetailLabel
extension HDTimelineController {
    
    func bindSelectedDateToDateDetailLabel(observable: Observable<Date>, label: UILabel) {
        observable
            .asDriver(onErrorJustReturn: Date())
            .drive(onNext : { [unowned label] (date) in
                label.text = date.formatted(components: [.dayOfWeekWideName,
                                                         .comma,
                                                         .whitespace,
                                                         .dayOfMonth,
                                                         .whitespace,
                                                         .monthOfYearFullName,
                                                         .whitespace,
                                                         .yearFullDigits])
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindActivityToTableView
extension HDTimelineController {
    
    func bindActivityToTableView(observable: Observable<[[ActivityDomain]]>, tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        observable
            .asDriver(onErrorJustReturn: [[]])
            .map { $0.map { SectionModel(model: "", items: $0) } }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, ActivityDomain>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ActivityDomain>>
        { [unowned self] (_, _, _, item) -> UITableViewCell in
            let identifier = self.timelineView.HDTLActivityTableCellIdentifier
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.explanation
            return cell
        }
        return dataSource
    }
    
}

// MARK: BindCalendarItems
extension HDTimelineController {
    
    func bindCalendarItems(observable: Observable<[HDTLCalendarItemDomain]>) {
        observable
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] (calendarItems) in
                self.calendarItems = calendarItems
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCalendarItemsToCollectionView
extension HDTimelineController {
    
    func bindCalendarItemsToCollectionView(observable: Observable<[HDTLCalendarItemDomain]>,
                                           collectionView: UICollectionView) {
        let dataSource = self.makeCollectionViewDataSource()
        observable
            .asDriver(onErrorJustReturn: [])
            .map { [HDTLCalendarItemDomainSectionModel(model: "", items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeCollectionViewDataSource() -> RxCollectionViewSectionedAnimatedDataSource<HDTLCalendarItemDomainSectionModel> {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<HDTLCalendarItemDomainSectionModel>
        { (_, collectionView, index, item) -> UICollectionViewCell in
            let identifier = HDTLCalendarItemCollectionCell.identifier
            let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: index)
            guard let cell = reusableCell as? HDTLCalendarItemCollectionCell else {
                fatalError("Cannot dequeueReusableCell() with identifier: \(identifier)")
            }
            if item.date.timeIntervalSince1970 != -1 {
                cell.dateFormatted = item.date.formatted(components: [.dayOfMonth])
            } else {
                cell.dateFormatted = nil
            }
            return cell
        }
        return dataSource
    }
    
}

// MARK: BindCollectionViewModelSelectedToDateDetailLabel
extension HDTimelineController {
    
    func bindCollectionViewModelSelectedToDateDetailLabel(collectionView: UICollectionView, label: UILabel) {
        collectionView.rx
            .modelSelected(HDTLCalendarItemDomain.self)
            .asDriver()
            .drive(onNext: { [unowned label] (calendarItem) in
                guard calendarItem.date.timeIntervalSince1970 != -1 else { return }
                label.text = calendarItem.dateFormatted
            })
            .disposed(by: self.disposeBag)
    }
    
}

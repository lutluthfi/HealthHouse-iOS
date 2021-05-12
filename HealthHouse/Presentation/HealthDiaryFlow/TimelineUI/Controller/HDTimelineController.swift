//
//  HDTimelineController.swift
//  HealthHouse
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
            .calendarCollectionView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        self.view = self._view
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindCalendarItems(calendarItems: self.timelineView.calendarItems)
        self.bindCalendarItemsToCalendarCollectionView(calendarItems: self.timelineView.calendarItems,
                                                       collectionView: self.timelineView.calendarCollectionView)
        self.bindCalendarCollectionModelSelectedToNavigationItemTitle(collectionView: self.timelineView.calendarCollectionView,
                                                                      navigationItem: self.navigationItem)
        self.bindSelectedDateToNavigationItemTitle(selectedDate: self._selectedDate,
                                                   navigationItem: self.navigationItem)
        self.bindShowedActivitiesViewModelToTimelineTableView(showedActivities: self.viewModel.showedActivities,
                                                              tableView: self.timelineView.timelineTableView)
        self.timelineView.viewDidLoad(navigationController: self.navigationController,
                                      tabBarController: self.tabBarController,
                                      navigationItem: self.navigationItem)
        self.viewModel.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timelineView.viewWillAppear(navigationController: self.navigationController,
                                         tabBarController: self.tabBarController)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.calendarCollectionViewDidInitialSelectItem(collectionView: self.timelineView.calendarCollectionView,
                                                        calendarItems: self.calendarItems)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timelineView.viewWillDisappear()
    }
    
}

// MARK: Private Function
private extension HDTimelineController {
    
    func calendarCollectionViewDidInitialSelectItem(collectionView: UICollectionView,
                                                    calendarItems: [HDTLCalendarItemDomain]) {
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
        let todayIndex = calendarItems.index(of: todayCalendarItem)
        guard let _todayIndex = todayIndex else { return }
        let selectedIndex = IndexPath(row: _todayIndex, section: 0)
        collectionView.selectItem(at: selectedIndex, animated: false, scrollPosition: .centeredHorizontally)
    }
    
}

// MARK: BindCalendarItems
extension HDTimelineController {
    
    func bindCalendarItems(calendarItems: Observable<[HDTLCalendarItemDomain]>) {
        calendarItems
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] (calendarItems) in
                self.calendarItems = calendarItems
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCalendarItemsToCalendarCollectionView
extension HDTimelineController {
    
    func bindCalendarItemsToCalendarCollectionView(calendarItems: Observable<[HDTLCalendarItemDomain]>,
                                                   collectionView: UICollectionView) {
        let dataSource = self.makeCollectionViewDataSource()
        calendarItems
            .asDriver(onErrorJustReturn: [])
            .map({ [HDTLCalendarItemDomainSectionModel(model: "", items: $0)] })
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
                cell.date = item.date
            } else {
                cell.date = nil
            }
            return cell
        }
        return dataSource
    }
    
}

// MARK: BindCalendarCollectionModelSelectedToNavigationItemTitle
extension HDTimelineController {
    
    func bindCalendarCollectionModelSelectedToNavigationItemTitle(collectionView: UICollectionView,
                                                                  navigationItem: UINavigationItem) {
        collectionView.rx
            .modelSelected(HDTLCalendarItemDomain.self)
            .asDriver()
            .filter({ $0.date.timeIntervalSince1970 != -1 })
            .map({ $0.dateFormatted })
            .drive(navigationItem.rx.title)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindSelectedDateToDateDetailLabel
extension HDTimelineController {
    
    func bindSelectedDateToNavigationItemTitle(selectedDate: Observable<Date>, navigationItem: UINavigationItem) {
        selectedDate
            .asDriver(onErrorJustReturn: Date())
            .map({ $0.formatted(components: [.dayOfWeekWideName,
                                             .comma,
                                             .whitespace,
                                             .dayOfMonth,
                                             .whitespace,
                                             .monthOfYearFullName,
                                             .whitespace,
                                             .yearFullDigits])
            })
            .drive(navigationItem.rx.title)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindShowedActivitiesViewModelToTimelineTableView
extension HDTimelineController {
    
    func bindShowedActivitiesViewModelToTimelineTableView(showedActivities: Observable<[ActivityDomain]>,
                                                          tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        showedActivities
            .asDriver(onErrorJustReturn: [])
            .map({ [SectionDomain<ActivityDomain>(header: "", items: $0)] })
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionDomain<ActivityDomain>> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionDomain<ActivityDomain>>
        { [unowned self] (_, _, _, item) -> UITableViewCell in
            let identifier = self.timelineView.HDTLActivityTableCellIdentifier
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
            cell.selectionStyle = .none
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.doDate.toDate().formatted(components: [.hour12Padding,
                                                                                     .colon,
                                                                                     .minutePadding,
                                                                                     .whitespace,
                                                                                     .meridiem])
            cell.imageView?.image = UIImage(named: "image.placeholder")
            return cell
        }
        return dataSource
    }
    
}

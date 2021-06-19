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
    lazy var disposeBag = DisposeBag()
    lazy var _view: HDTimelineView = DefaultHDTimelineView()
    var viewModel: HDTimelineViewModel!
    
    // MARK: Common Variable
    let _selectedDate = BehaviorSubject<Date>(value: Date())
    var calendarItems: [HDTLCalendarItemModel] = []
    
    // MARK: Create Function
    class func create(with viewModel: HDTimelineViewModel) -> HDTimelineController {
        let controller = HDTimelineController()
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: UIViewController Function
    public override func loadView() {
        self._view.calendarCollectionView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        self.view = self._view.asView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindAddBarButtonItemTap(addBarButton: self._view.addBarButtonItem)
        self.bindCalendarItems(calendarItems: self._view.calendarItems)
        self.bindCalendarCollectionModelSelectedToNavigationItemTitle(collectionView: self._view.calendarCollectionView,
                                                                      navigationItem: self.navigationItem)
        self.bindSelectedDateToNavigationItemTitle(selectedDate: self._selectedDate,
                                                   navigationItem: self.navigationItem)
        self.bindShowedActivitiesViewModelToEmptyViewHidden(showedActivities: self.viewModel.showedActivities,
                                                            emptyViewHidden: self._view.emptyView.rx.isHidden)
        self.bindShowedActivitiesViewModelToTimelineTableViewHidden(showedActivities: self.viewModel.showedActivities,
                                                                    tableViewHidden: self._view.timelineTableView.rx.isHidden)
        self._view.viewDidLoad(navigationController: self.navigationController,
                               tabBarController: self.tabBarController,
                               navigationItem: self.navigationItem)
        self.viewModel.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._view.viewWillAppear(navigationController: self.navigationController,
                                  tabBarController: self.tabBarController)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bindCalendarItemsToCalendarCollectionView(calendarItems: self._view.calendarItems,
                                                       collectionView: self._view.calendarCollectionView)
        self.bindShowedActivitiesViewModelToTimelineTableView(showedActivities: self.viewModel.showedActivities,
                                                              tableView: self._view.timelineTableView)
        self.calendarCollectionViewDidInitialSelectItem(collectionView: self._view.calendarCollectionView,
                                                        calendarItems: self.calendarItems)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._view.viewWillDisappear()
    }
    
}

// MARK: Private Function
private extension HDTimelineController {
    
    func calendarCollectionViewDidInitialSelectItem(collectionView: UICollectionView,
                                                    calendarItems: [HDTLCalendarItemModel]) {
        let now = Date()
        let nowFormatted = now.formatted(components: [.dayOfWeekWideName,
                                                      .comma,
                                                      .whitespace,
                                                      .dayOfMonth,
                                                      .whitespace,
                                                      .monthOfYearFullName,
                                                      .whitespace,
                                                      .yearFullDigits])
        let todayCalendarItem = HDTLCalendarItemModel(date: now, dateFormatted: nowFormatted)
        let todayIndex = calendarItems.index(of: todayCalendarItem)
        guard let _todayIndex = todayIndex else { return }
        let selectedIndex = IndexPath(row: _todayIndex, section: 0)
        collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .centeredHorizontally)
    }
    
}

// MARK: BindAddBarButtonItemTap
extension HDTimelineController {
    
    func bindAddBarButtonItemTap(addBarButton: UIBarButtonItem) {
        addBarButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.viewModel.addBarButtonDidTap()
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCalendarItems
extension HDTimelineController {
    
    func bindCalendarItems(calendarItems: Observable<[HDTLCalendarItemModel]>) {
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
    
    func bindCalendarItemsToCalendarCollectionView(calendarItems: Observable<[HDTLCalendarItemModel]>,
                                                   collectionView: UICollectionView) {
        let dataSource = self.makeCollectionViewDataSource()
        calendarItems
            .asDriver(onErrorJustReturn: [])
            .map({ [HDTLCalendarItemModelSectionModel(model: "", items: $0)] })
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeCollectionViewDataSource() -> RxCollectionViewSectionedAnimatedDataSource<HDTLCalendarItemModelSectionModel> {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<HDTLCalendarItemModelSectionModel>
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
            .modelSelected(HDTLCalendarItemModel.self)
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
            .map({
                let formattedComponents: [Date.FormatterComponent] = [.dayOfWeekWideName,
                                                                      .comma,
                                                                      .whitespace,
                                                                      .dayOfMonth,
                                                                      .whitespace,
                                                                      .monthOfYearFullName,
                                                                      .whitespace,
                                                                      .yearFullDigits]
                return $0.formatted(components: formattedComponents)
            })
            .drive(navigationItem.rx.title)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindShowedActivitiesViewModelToEmptyView
extension HDTimelineController {
    
    func bindShowedActivitiesViewModelToEmptyViewHidden(showedActivities: Observable<[Activity]>,
                                                        emptyViewHidden: Binder<Bool>) {
        showedActivities
            .asDriver(onErrorJustReturn: [])
            .map({ !$0.isEmpty })
            .drive(emptyViewHidden)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindShowedActivitiesViewModelToTimelineTableView
extension HDTimelineController {
    
    func bindShowedActivitiesViewModelToTimelineTableView(showedActivities: Observable<[Activity]>,
                                                          tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        showedActivities
            .asDriver(onErrorJustReturn: [])
            .map({ [SectionDomain<Activity>(header: "", items: $0)] })
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionDomain<Activity>> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionDomain<Activity>>
        { [unowned self] (_, _, _, item) -> UITableViewCell in
            let identifier = self._view.HDTLActivityTableCellIdentifier
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
            cell.selectionStyle = .none
            cell.textLabel?.text = item.title
            let formattedComponents: [Date.FormatterComponent] = [.hour12Padding,
                                                                  .colon,
                                                                  .minutePadding,
                                                                  .whitespace,
                                                                  .meridiem]
            cell.detailTextLabel?.text = item.doDate.toDate().formatted(components: formattedComponents)
            cell.imageView?.image = UIImage(named: "image.placeholder")
            return cell
        }
        return dataSource
    }
    
}

// MARK: BindShowedActivitiesViewModelToTimelineTableViewHidden
extension HDTimelineController {
    
    func bindShowedActivitiesViewModelToTimelineTableViewHidden(showedActivities: Observable<[Activity]>,
                                                                tableViewHidden: Binder<Bool>) {
        showedActivities
            .asDriver(onErrorJustReturn: [])
            .map({ $0.isEmpty })
            .drive(tableViewHidden)
            .disposed(by: self.disposeBag)
    }
    
}

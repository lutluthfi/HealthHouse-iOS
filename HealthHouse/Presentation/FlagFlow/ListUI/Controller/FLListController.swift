//
//  LBListController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/05/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: FLListController
final class FLListController: UITableViewController {
    
    // MARK: DI Variable
    lazy var disposeBag = DisposeBag()
    lazy var _view: FLListView = DefaultFLListView()
    var viewModel: FLListViewModel!
    
    // MARK: Common Variable
    let _isTableEditing = BehaviorRelay<Bool>(value: false)
    let _selectedLabels = BehaviorRelay<[FlagDomain]>(value: [])
    
    // MARK: Create Function
    class func create(with viewModel: FLListViewModel) -> FLListController {
        let controller = FLListController()
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: UIViewController Function
    override func loadView() {
        self._view.tableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        self.view = self._view.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindSelectedLabelsToSelectedCountBarButtonItem(selectedLabels: self._selectedLabels,
                                                            barButtonItem: self._view.selectedCountBarButtonItem)
        self.bindCreateBarButtonItemTap(barButtonItem: self._view.createBarButtonItem)
        self.bindDoneBarButtonItemTap(barButtonItem: self._view.doneBarButtonItem)
        self.bindTableViewModelDeselected(tableView: self._view.tableView)
        self.bindTableViewModelSelected(tableView: self._view.tableView)
        self.bindTableViewItemSelected(tableView: self._view.tableView)
        self.bindTableViewItemDeselected(tableView: self._view.tableView)
        self.bindTableViewWillDisplayCell(tableView: self._view.tableView)
        self.bindShowedLabelsToTableView(showedLabels: self.viewModel.showedLabels, tableView: self._view.tableView)
        self.bindShowedLabelsToSelectedLabels(showedLabels: self.viewModel.showedLabels,
                                              selectedLabels: self._selectedLabels)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._view.viewWillAppear(navigationController: self.navigationController,
                                     navigationItem: self.navigationItem,
                                     tabBarController: self.tabBarController,
                                     toolbarItems: &self.toolbarItems)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._view.viewWillDisappear()
    }
    
}

// MARK: BindAddBarButtonItemTap
extension FLListController {
    
    func bindCreateBarButtonItemTap(barButtonItem: UIBarButtonItem) {
        barButtonItem.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.viewModel.presentLBCreateUI()
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindDoneBarButtonItemTap
extension FLListController {
    
    func bindDoneBarButtonItemTap(barButtonItem: UIBarButtonItem) {
        barButtonItem.rx
            .tap
            .withLatestFrom(self._selectedLabels)
            .asDriver(onErrorJustReturn: [])
            .do(onNext: { [unowned self] (labels) in
                self.viewModel.doDone(selectedLabels: labels)
            })
            .drive(onNext: { [unowned self] (_) in
                self.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindSelectedLabelsToSelectedCountBarButtonItem
extension FLListController {
    
    func bindSelectedLabelsToSelectedCountBarButtonItem(selectedLabels: BehaviorRelay<[FlagDomain]>,
                                                        barButtonItem: UIBarButtonItem) {
        selectedLabels
            .asDriver()
            .map({ $0.count })
            .map({
                let isGreaterThanOne = $0 > 1
                let isGreaterThanZero = $0 > 0
                let label = isGreaterThanOne ? "Labels" : "Label"
                return isGreaterThanZero ? "\($0) \(label) Selected" : ""
            })
            .drive(barButtonItem.rx.title)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindShowedLabelsToSelectedLabels
extension FLListController {
    
    func bindShowedLabelsToSelectedLabels(showedLabels: PublishRelay<[SelectableDomain<FlagDomain>]>,
                                          selectedLabels: BehaviorRelay<[FlagDomain]>) {
        showedLabels
            .asDriver(onErrorJustReturn: [])
            .map({ $0.filter({ $0.selected }) })
            .map({ $0.map({ $0.value }) })
            .drive(selectedLabels)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewItemDeselected
extension FLListController {
    
    func bindTableViewItemDeselected(tableView: UITableView) {
        tableView.rx
            .itemDeselected
            .asDriver()
            .map({ [unowned tableView] in tableView.cellForRow(at: $0) })
            .drive(onNext: { (cell) in
                cell?.accessoryType = .none
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewItemSelected
extension FLListController {
    
    func bindTableViewItemSelected(tableView: UITableView) {
        tableView.rx
            .itemSelected
            .withLatestFrom(self._selectedLabels) { ($0, $1) }
            .filter({ $0.1.count < 5 })
            .map({ [unowned tableView] in tableView.cellForRow(at: $0.0) })
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { (cell) in
                cell?.accessoryType = .checkmark
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewModelDeselected
extension FLListController {
    
    func bindTableViewModelDeselected(tableView: UITableView) {
        tableView.rx
            .modelDeselected(SelectableDomain<FlagDomain>.self)
            .asDriver()
            .map({ $0.value })
            .map({ [unowned self] (label) -> [FlagDomain] in
                var value = self._selectedLabels.value
                value.remove(firstIndexOf: label)
                return value
            })
            .drive(self._selectedLabels)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewModelSelected
extension FLListController {
    
    func bindTableViewModelSelected(tableView: UITableView) {
        tableView.rx
            .modelSelected(SelectableDomain<FlagDomain>.self)
            .asDriver()
            .map({ $0.value })
            .map({ [unowned self] (label) -> [FlagDomain] in
                var value = self._selectedLabels.value
                value.append(label)
                return value
            })
            .drive(self._selectedLabels)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewWillDisplayCell
extension FLListController {
    
    func bindTableViewWillDisplayCell(tableView: UITableView) {
        tableView.rx
            .willDisplayCell
            .asDriver()
            .drive(onNext: { (event) in
                let cell = event.cell
                let isCellSelected = cell.isSelected
                cell.accessoryType = isCellSelected ? .checkmark : .none
            })
            .disposed(by: self.disposeBag)
    }
    
}

extension FLListController {
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, _) in
            
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    
}

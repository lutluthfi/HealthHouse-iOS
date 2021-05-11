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

// MARK: LBListController
final class LBListController: UITableViewController {
    
    // MARK: DI Variable
    let disposeBag = DisposeBag()
    lazy var listView: LBListView = DefaultLBListView()
    var viewModel: LBListViewModel!
    
    // MARK: Common Variable
    let _isTableEditing = BehaviorRelay<Bool>(value: false)
    let _selectedLabels = BehaviorRelay<[LabelDomain]>(value: [])
    
    // MARK: Create Function
    class func create(with viewModel: LBListViewModel) -> LBListController {
        let controller = LBListController()
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: UIViewController Function
    override func loadView() {
        self.listView.tableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        self.view = self.listView.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindSelectedLabelsToSelectedCountBarButtonItem(relay: self._selectedLabels,
                                                            barButtonItem: self.listView.selectedCountBarButtonItem)
        self.bindDoneBarButtonItemTap(barButtonItem: self.listView.doneBarButtonItem)
        self.bindTableViewModelDeselected(tableView: self.listView.tableView)
        self.bindTableViewModelSelected(tableView: self.listView.tableView)
        self.bindTableViewItemSelected(tableView: self.listView.tableView)
        self.bindTableViewItemDeselected(tableView: self.listView.tableView)
        self.bindTableViewWillDisplayCell(tableView: self.listView.tableView)
        self.bindShowedLabelsToTableView(relay: self.viewModel.showedLabels, tableView: self.listView.tableView)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listView.viewWillAppear(navigationController: self.navigationController,
                                     navigationItem: self.navigationItem,
                                     tabBarController: self.tabBarController,
                                     toolbarItems: &self.toolbarItems)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.listView.viewWillDisappear()
    }
    
}

// MARK: BindDoneBarButtonItemTap
extension LBListController {
    
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

// MARK: BindSelectedLabelsToNavigationItemPrompt
extension LBListController {
    
    func bindSelectedLabelsToSelectedCountBarButtonItem(relay: BehaviorRelay<[LabelDomain]>,
                                                        barButtonItem: UIBarButtonItem) {
        relay
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

// MARK: BindTableViewItemDeselected
extension LBListController {
    
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
extension LBListController {
    
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
extension LBListController {
    
    func bindTableViewModelDeselected(tableView: UITableView) {
        tableView.rx
            .modelDeselected(SelectableDomain<LabelDomain>.self)
            .asDriver()
            .map({ $0.value })
            .map({ [unowned self] (label) -> [LabelDomain] in
                var value = self._selectedLabels.value
                value.remove(firstIndexOf: label)
                return value
            })
            .drive(self._selectedLabels)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewModelSelected
extension LBListController {
    
    func bindTableViewModelSelected(tableView: UITableView) {
        tableView.rx
            .modelSelected(SelectableDomain<LabelDomain>.self)
            .asDriver()
            .map({ $0.value })
            .map({ [unowned self] (label) -> [LabelDomain] in
                var value = self._selectedLabels.value
                value.append(label)
                return value
            })
            .drive(self._selectedLabels)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewWillDisplayCell
extension LBListController {
    
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

extension LBListController {
    
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

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
    
    
    // MARK: Create Function
    class func create(with viewModel: LBListViewModel) -> LBListController {
        let controller = LBListController()
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: UIViewController Function
    override func loadView() {
        self.view = self.listView.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindDoneBarButtonItemTap(barButtonItem: self.listView.doneBarButtonItem)
        self.bindTableViewModelSelected(tableView: self.listView.tableView)
        self.bindTableViewItemSelected(tableView: self.listView.tableView)
        self.bindTableViewItemDeselected(tableView: self.listView.tableView)
        self.bindLabelToTableView(relay: self.viewModel.showedLabels, tableView: self.listView.tableView)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listView.viewWillAppear(navigationBar: self.navigationController?.navigationBar,
                                     navigationItem: self.navigationItem,
                                     tabBarController: self.tabBarController)
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
            .asDriver()
            .drive(onNext: { [unowned self] in
                
                self.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindLabelToTableView
extension LBListController {

    func bindLabelToTableView(relay: PublishRelay<[SelectableDomain<LabelDomain>]>, tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        relay
            .asDriver(onErrorJustReturn: [])
            .map({ [SectionDomain(header: "", items: $0)] })
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    func makeTableViewDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionDomain<SelectableDomain<LabelDomain>>> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionDomain<SelectableDomain<LabelDomain>>>
        { (_, tableView, index, item) -> UITableViewCell in
            let cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultTableCell")
            cell.selectionStyle = .none
            cell.textLabel?.text = item.value.name
            if item.selected {
                cell.accessoryType = .checkmark
                tableView.selectRow(at: index, animated: true, scrollPosition: .none)
            } else {
                cell.accessoryType = .none
                tableView.deselectRow(at: index, animated: true)
            }
            return cell
        }
        return dataSource
    }
    
}

// MARK: BindTableViewItemDeselected
extension LBListController {
    
    func bindTableViewItemDeselected(tableView: UITableView) {
        tableView.rx
            .itemDeselected
            .asDriver()
            .drive(onNext: { [unowned tableView] (index) in
                let cell = tableView.cellForRow(at: index)
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
            .asDriver()
            .drive(onNext: { [unowned tableView] (index) in
                let cell = tableView.cellForRow(at: index)
                cell?.accessoryType = .checkmark
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewModelSelected
extension LBListController {
    
    func bindTableViewModelSelected(tableView: UITableView) {
        tableView.rx
            .modelSelected(SelectableDomain<LabelDomain>.self)
            .asDriver()
            .drive(onNext: { [unowned self] (model) in
                let label = model.value
                self.viewModel.doSelect(label: label)
            })
            .disposed(by: self.disposeBag)
    }
    
}

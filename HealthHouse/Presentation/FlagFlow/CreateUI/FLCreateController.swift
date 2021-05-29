//
//  FLCreateController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: FLCreateController
final class FLCreateController: UITableViewController {

    // MARK: DI Variable
    lazy var disposeBag = DisposeBag()
    lazy var _view: FLCreateView = DefaultFLCreateView()
    var viewModel: FLCreateViewModel!

    // MARK: Common Variable
    lazy var _title = BehaviorRelay<String>(value: "")
    lazy var _color = BehaviorRelay<UIColor?>(value: nil)
    lazy var _fieldValues = Observable.combineLatest(self._title, self._color)

    // MARK: Create Function
    class func create(with viewModel: FLCreateViewModel) -> FLCreateController {
        let controller = FLCreateController()
        controller.viewModel = viewModel
        return controller
    }

    // MARK: UIViewController Function
    override func loadView() {
        self.view = self._view.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindCreateBarButtonItem(barButtonItem: self._view.createBarButtonItem)
        self.bindSectionsToTableView(sections: self._view.sections, tableView: self._view.tableView)
        self.bindTableViewItemDeselected(tableView: self._view.tableView)
        self.bindTableViewItemSelected(tableView: self._view.tableView)
        self.bindTableViewModelSelectedToColor(tableView: self._view.tableView, color: self._color)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._view.viewWillAppear(navigationBar: self.navigationController?.navigationBar,
                                  navigationItem: self.navigationItem,
                                  tabBarController: self.tabBarController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._view.viewWillDisappear()
    }
    
}

// MARK: BindCreateBarButtonItem
extension FLCreateController {
    
    func bindCreateBarButtonItem(barButtonItem: UIBarButtonItem) {
        barButtonItem.rx.tap
            .withLatestFrom(self._fieldValues)
            .filter({ $0.1 != nil })
            .do(onNext: { [unowned self] (fieldValues) in
                let name = fieldValues.0
                let hexcolor = fieldValues.1!.hexString()
                self.viewModel.doCreate(hexcolor: hexcolor, name: name)
            })
            .bind(onNext: { [unowned self] (_) in
                self.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewItemDeselected
extension FLCreateController {
    
    func bindTableViewItemDeselected(tableView: UITableView) {
        tableView.rx
            .itemDeselected
            .map({ [unowned tableView] in tableView.cellForRow(at: $0) })
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { (cell) in
                cell?.accessoryType = .none
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewItemSelected
extension FLCreateController {
    
    func bindTableViewItemSelected(tableView: UITableView) {
        tableView.rx
            .itemSelected
            .map({ [unowned tableView] in tableView.cellForRow(at: $0) })
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { (cell) in
                cell?.accessoryType = .checkmark
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewModelSelectedToColor
extension FLCreateController {
    
    func bindTableViewModelSelectedToColor(tableView: UITableView, color: BehaviorRelay<UIColor?>) {
        tableView.rx
            .modelSelected(RowDomain.self)
            .asDriver()
            .compactMap({ $0.value as? UIColor })
            .drive(self._color)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindSectionsToTableView
extension FLCreateController {
    
    func bindSectionsToTableView(sections: BehaviorRelay<[SectionDomain<RowDomain>]>, tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        sections
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionDomain<RowDomain>> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionDomain<RowDomain>>
        { (_, _, _, item) -> UITableViewCell in
            if let color = item.value as? UIColor {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultTableCell")
                cell.selectionStyle = .none
                cell.textLabel?.text = item.identify
                let circleBadgeFill = UIImage(systemName: "flag.circle.fill")
                cell.imageView?.image = circleBadgeFill
                cell.imageView?.tintColor = color
                return cell
            } else {
                let cell = TextFieldTableCell(style: .plain)
                cell.textField.placeholder = item.identify
                cell.textField.autocapitalizationType = .words
                cell.textField.clearButtonMode = .whileEditing
                self.bindTextFieldToTitle(textField: cell.textField, title: self._title)
                return cell
            }
        }
        dataSource.titleForFooterInSection = { [unowned self] (_dataSource, row) -> String? in
            let model = self._view.sections.value[row]
            let footer = model.footer
            return footer
        }
        return dataSource
    }
    
}

// MARK: BindTextFieldToTitle
extension FLCreateController {
    
    func bindTextFieldToTitle(textField: UITextField, title: BehaviorRelay<String>) {
        textField.rx.text.orEmpty
            .asDriver()
            .drive(self._title)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: RxColorPickerDelegate
extension FLCreateController: RxColorPickerDelegate { }

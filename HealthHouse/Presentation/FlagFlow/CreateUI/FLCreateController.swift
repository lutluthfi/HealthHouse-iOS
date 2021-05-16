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
        self.bindSectionsToTableView(relay: self._view.sections, tableView: self._view.tableView)
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

// MARK: BindSectionsToTableView
extension FLCreateController {
    
    func bindSectionsToTableView(relay: BehaviorRelay<[SectionDomain<RowDomain>]>, tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        relay
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionDomain<RowDomain>> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionDomain<RowDomain>>
        { (_, _, _, item) -> UITableViewCell in
            let cell = HHTextFieldTableCell(style: .plain)
            cell.textField.placeholder = item.identify
            cell.textField.autocapitalizationType = .words
            cell.textField.clearButtonMode = .whileEditing
            return cell
        }
        dataSource.titleForFooterInSection = { [unowned self] (_dataSource, row) -> String? in
            let model = self._view.sections.value[row]
            let footer = model.footer
            return footer
        }
        return dataSource
    }
    
}

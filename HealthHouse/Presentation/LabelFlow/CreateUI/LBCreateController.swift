//
//  LBCreateController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: LBCreateController
final class LBCreateController: UITableViewController {

    // MARK: DI Variable
    lazy var createView: LBCreateView = DefaultLBCreateView()
    lazy var disposeBag = DisposeBag()
    var viewModel: LBCreateViewModel!

    // MARK: Common Variable


    // MARK: Create Function
    class func create(with viewModel: LBCreateViewModel) -> LBCreateController {
        let controller = LBCreateController()
        controller.viewModel = viewModel
        return controller
    }

    // MARK: UIViewController Function
    override func loadView() {
        self.view = self.createView.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindSectionsToTableView(relay: self.createView.sections, tableView: self.createView.tableView)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createView.viewWillAppear(navigationBar: self.navigationController?.navigationBar,
                                  navigationItem: self.navigationItem,
                                  tabBarController: self.tabBarController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.createView.viewWillDisappear()
    }
    
}

// MARK: BindSectionsToTableView
extension LBCreateController {
    
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
            let model = self.createView.sections.value[row]
            let footer = model.footer
            return footer
        }
        return dataSource
    }
    
}

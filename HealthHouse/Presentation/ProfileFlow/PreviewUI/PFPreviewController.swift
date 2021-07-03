//
//  PFPreviewController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: PFPreviewController
public final class PFPreviewController: UITableViewController {

    // MARK: DI Variable
    lazy var _view: PFPreviewView = DefaultPFPreviewView()
    var viewModel: PFPreviewViewModel!

    // MARK: Common Variable
    let disposeBag = DisposeBag()

    // MARK: Create Function
    class func create(with viewModel: PFPreviewViewModel) -> PFPreviewController {
        let controller = PFPreviewController()
        controller.viewModel = viewModel
        return controller
    }

    // MARK: UIViewController Function
    public override func loadView() {
        self.view = self._view.tableView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel
            .loadingState
            .bind(onNext: { [weak self] (state) in
                switch state {
                case .willHide:
                    self?._view.tableView.hideLoadingIndicator()
                case .willShow:
                    self?._view.tableView.showLoadingIndicator()
                }
            })
            .disposed(by: self.disposeBag)
        self.bind(sections: self._view.sections,
                  showedProfileViewModel: self.viewModel.showedProfile,
                  toTableView: self._view.tableView)
        self.viewModel.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._view.viewWillAppear(navigationController: self.navigationController,
                                  tabBarController: self.tabBarController)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.viewDidAppear()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._view.viewWillDisappear()
    }
    
}

extension PFPreviewController {
    
    func bind(sections: Observable<[SectionDomain<RowDomain>]>,
              showedProfileViewModel profile: PublishRelay<Profile?>,
              toTableView tableView: UITableView) {
        let dataSource = self.makeTableDataSource(profile: profile)
        profile
            .compactMap({ $0 })
            .withLatestFrom(sections) { profile, sections -> [SectionDomain<RowDomain>] in
                var _sections = sections
                let allergyRows = profile.allergy.map({ RowDomain(identify: "allergy-\($0)", value: $0) })
                _sections[1].items = allergyRows
                return _sections
            }
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    func bind(showedProfileViewModel profile: PublishRelay<Profile?>, toTableCell cell: UITableViewCell) {
        profile
            .asDriver(onErrorJustReturn: nil)
            .compactMap({ $0 })
            .drive(onNext: { [unowned cell] (profile) in
                cell.textLabel?.text = profile.fullName
                if let photoBase64String = profile.photoBase64String,
                   let photoData = Data(base64Encoded: photoBase64String){
                    cell.imageView?.image = UIImage(data: photoData)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableDataSource(profile: PublishRelay<Profile?>) -> RxTableViewSectionedAnimatedDataSource<SectionDomain<RowDomain>> {
        .init { [unowned profile] (dataSource, tableView, indexPath, item) -> UITableViewCell in
            if item == .photoWithName {
                let reuseIdentifier = "SubtitleTableCell"
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
                cell.selectionStyle = .none
                self.bind(showedProfileViewModel: profile, toTableCell: cell)
                return cell
            } else if item.identify.contains("allergy-") {
                let reuseIdentifier = "DefaultTableCell"
                let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
                cell.selectionStyle = .none
                cell.textLabel?.text = item.value as? String
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
}

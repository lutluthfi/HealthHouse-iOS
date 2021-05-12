//
//  LBListController+BindShowedLabelsToTableView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 08/05/21.
//

import RxCocoa
import RxDataSources
import RxSwift

// MARK: BindShowedLabelsToTableView
extension LBListController {
    
    func bindShowedLabelsToTableView(showedLabels: PublishRelay<[SelectableDomain<LabelDomain>]>,
                                     tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        showedLabels
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
            if item.selected {
                tableView.selectRow(at: index, animated: true, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: index, animated: true)
            }
            cell.textLabel?.text = item.value.name
            let circleBadgeFill = UIImage(systemName: "flag.circle.fill")
            cell.imageView?.image = circleBadgeFill
            cell.imageView?.tintColor = UIColor(hex: item.value.hexcolor)
            return cell
        }
        dataSource.canEditRowAtIndexPath = { (dataSource, index) -> Bool in
            return true
        }
        return dataSource
    }
    
}

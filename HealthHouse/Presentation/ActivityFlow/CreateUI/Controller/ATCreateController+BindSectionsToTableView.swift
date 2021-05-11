//
//  ATCreateController+BindSectionsToTableView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 29/04/21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: BindSectionsToTableView
extension ATCreateController {
    
    func bindSectionsToTableView(relay: BehaviorRelay<[SectionDomain<RowDomain>]>, tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        relay
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionDomain<RowDomain>> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionDomain<RowDomain>>(animationConfiguration: AnimationConfiguration(insertAnimation: .bottom, reloadAnimation: .bottom, deleteAnimation: .bottom))
        { [unowned self] (_, tableView, _, item) -> UITableViewCell in
            if let label = item.value as? LabelDomain {
                let cell = makeDefaultTableCell()
                cell.selectionStyle = .none
                cell.textLabel?.text = label.name
                let circleBadgeFill = UIImage(systemName: "circlebadge.fill")
                cell.imageView?.image = circleBadgeFill
                cell.imageView?.tintColor = UIColor(hex: label.hexcolor)
                return cell
            }
            switch item {
            case .attachment:
                let cell = self.makeSubtitleTableCell()
                cell.textLabel?.text = item.identify
                cell.accessoryType = .disclosureIndicator
                return cell
            case .date:
                let cell = self.makeValue1TableCell()
                cell.imageView?.image = UIImage(named: "calendar.round.color")
                cell.textLabel?.text = item.identify
                cell.detailTextLabel?.text = ""
                self.bindDateToDateLabel(relay: self._date, label: cell.detailTextLabel!)
                return cell
            case .datePicker:
                let cell = self.makeHHDatePickerTableCell()
                cell.datePicker.datePickerMode = .date
                if #available(iOS 13.4, *) {
                    cell.datePicker.preferredDatePickerStyle = .wheels
                }
                self.bindDatePickerToDateOrTime(picker: cell.datePicker, relay: self._date)
                return cell
            case .explanation:
                let cell = HHTextViewTableCell()
                cell.placeholderLabel.text = item.identify
                self.bindTextViewDidChangeToPlaceholderLabelHidden(textView: cell.textView,
                                                                   label: cell.placeholderLabel)
                return cell
            case .label:
                let cell = self.makeSubtitleTableCell()
                cell.selectionStyle = .none
                cell.textLabel?.text = item.identify
                cell.accessoryType = .disclosureIndicator
                return cell
            case .location:
                let cell = self.makeSubtitleTableCell()
                cell.textLabel?.text = item.identify
                cell.accessoryType = .disclosureIndicator
                self.bindSelectedLocationViewModelToLocationLabel(relay: self.viewModel.selectedLocation,
                                                                  label: cell.detailTextLabel!)
                return cell
            case .practitioner:
                let cell = makeHHTextFieldTableCell(with: item, style: .plain)
                cell.textField.autocapitalizationType = .words
                return cell
            case .time:
                let cell = self.makeValue1TableCell()
                cell.imageView?.image = UIImage(named: "clock.round.color")
                cell.textLabel?.text = item.identify
                cell.detailTextLabel?.text = ""
                self.bindTimeToTimeLabel(relay: self._time, label: cell.detailTextLabel!)
                return cell
            case .timePicker:
                let cell = self.makeHHDatePickerTableCell()
                cell.datePicker.datePickerMode = .time
                if #available(iOS 13.4, *) {
                    cell.datePicker.preferredDatePickerStyle = .wheels
                }
                self.bindDatePickerToDateOrTime(picker: cell.datePicker, relay: self._time)
                return cell
            case .title:
                let cell = makeHHTextFieldTableCell(with: item, style: .plain)
                cell.textField.autocapitalizationType = .words
                return cell
            default:
                let cell = self.makeDefaultTableCell()
                cell.textLabel?.text = item.identify
                return cell
            }
        }
        return dataSource
    }
    
    private func makeHHTextFieldTableCell(with item: RowDomain,
                                          style: HHTextFieldTableCellStyle) -> HHTextFieldTableCell {
        let cell = HHTextFieldTableCell(reuseIdentifier: HHTextFieldTableCell.identifier, style: style)
        cell.textField.placeholder = item.identify
        return cell
    }
    
    private func makeHHDatePickerTableCell() -> HHDatePickerTableCell {
        let cell = HHDatePickerTableCell()
        return cell
    }
    
    private func makeDefaultTableCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultTableCell")
        return cell
    }
    
    private func makeSubtitleTableCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SubtitleTableCell")
        return cell
    }
    
    private func makeValue1TableCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Value1TableCell")
        return cell
    }
    
}

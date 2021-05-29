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
    
    func bindSectionsToTableView(sections: BehaviorRelay<[SectionDomain<RowDomain>]>, tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        sections
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionDomain<RowDomain>> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionDomain<RowDomain>>
        { [unowned self] (_, tableView, _, item) -> UITableViewCell in
            if let label = item.value as? FlagDomain {
                let cell = makeDefaultTableCell(with: item)
                cell.selectionStyle = .none
                cell.textLabel?.text = label.name
                let circleBadgeFill = UIImage(systemName: "flag.circle.fill")
                cell.imageView?.image = circleBadgeFill
                cell.imageView?.tintColor = UIColor(label.hexcolor)
                return cell
            }
            switch item {
            case .attachment:
                let cell = self.makeSubtitleTableCell(with: item)
                cell.selectionStyle = .none
                cell.accessoryType = .disclosureIndicator
                return cell
            case .date:
                let cell = self.makeValue1TableCell(with: item)
                cell.selectionStyle = .none
                cell.imageView?.image = UIImage(named: "calendar.round.color")
                cell.detailTextLabel?.text = ""
                self.bindDateToDateLabel(date: self._date, label: cell.detailTextLabel!)
                return cell
            case .datePicker:
                let cell = self.makeHHDatePickerTableCell()
                cell.datePicker.datePickerMode = .date
                if #available(iOS 13.4, *) {
                    cell.datePicker.preferredDatePickerStyle = .wheels
                }
                self.bindDatePickerToDateOrTime(picker: cell.datePicker, dateOrTime: self._date)
                return cell
            case .explanation:
                let cell = TextViewTableCell()
                cell.placeholderLabel.text = item.identify
                self.bindTextViewDidChangeToPlaceholderLabelHidden(textView: cell.textView,
                                                                   label: cell.placeholderLabel)
                return cell
            case .flag:
                let cell = self.makeSubtitleTableCell(with: item)
                cell.selectionStyle = .none
                cell.accessoryType = .disclosureIndicator
                return cell
            case .location:
                let cell = self.makeSubtitleTableCell(with: item)
                cell.accessoryType = .disclosureIndicator
                self.bindSelectedLocationViewModelToLocationLabel(selectedLocation: self.viewModel.selectedLocation,
                                                                  label: cell.detailTextLabel!)
                return cell
            case .practitioner:
                let cell = makeHHTextFieldTableCell(with: item, style: .plain)
                cell.textField.autocapitalizationType = .words
                return cell
            case .time:
                let cell = self.makeValue1TableCell(with: item)
                cell.selectionStyle = .none
                cell.imageView?.image = UIImage(named: "clock.round.color")
                cell.detailTextLabel?.text = ""
                self.bindTimeToTimeLabel(time: self._time, label: cell.detailTextLabel!)
                return cell
            case .timePicker:
                let cell = self.makeHHDatePickerTableCell()
                cell.datePicker.datePickerMode = .time
                if #available(iOS 13.4, *) {
                    cell.datePicker.preferredDatePickerStyle = .wheels
                }
                self.bindDatePickerToDateOrTime(picker: cell.datePicker, dateOrTime: self._time)
                return cell
            case .title:
                let cell = makeHHTextFieldTableCell(with: item, style: .plain)
                cell.textField.autocapitalizationType = .words
                return cell
            default:
                let cell = self.makeDefaultTableCell(with: item)
                return cell
            }
        }
        return dataSource
    }
    
    private func makeHHTextFieldTableCell(with item: RowDomain,
                                          style: HHTextFieldTableCellStyle) -> TextFieldTableCell {
        let cell = TextFieldTableCell(reuseIdentifier: TextFieldTableCell.identifier, style: style)
        cell.textField.placeholder = item.identify
        return cell
    }
    
    private func makeHHDatePickerTableCell() -> DatePickerTableCell {
        let cell = DatePickerTableCell()
        return cell
    }
    
    private func makeDefaultTableCell(with item: RowDomain) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultTableCell")
        cell.textLabel?.text = item.identify
        return cell
    }
    
    private func makeSubtitleTableCell(with item: RowDomain) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SubtitleTableCell")
        cell.textLabel?.text = item.identify
        return cell
    }
    
    private func makeValue1TableCell(with item: RowDomain) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Value1TableCell")
        cell.textLabel?.text = item.identify
        return cell
    }
    
}

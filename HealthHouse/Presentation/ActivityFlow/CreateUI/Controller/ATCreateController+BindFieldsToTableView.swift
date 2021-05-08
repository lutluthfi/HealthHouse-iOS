//
//  ATCreateController+BindFieldsToTableView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 29/04/21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: BindFieldsToTableView
extension ATCreateController {
    
    func bindFieldsToTableView(relay: BehaviorRelay<[SectionDomain<FieldDomain>]>, tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        relay
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionDomain<FieldDomain>> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionDomain<FieldDomain>>(animationConfiguration: AnimationConfiguration(insertAnimation: .bottom, reloadAnimation: .bottom, deleteAnimation: .bottom))
        { [unowned self] (_, tableView, _, item) -> UITableViewCell in
            switch item {
            case .attachment:
                let cell = self.makeSubtitleTableCell()
                cell.textLabel?.text = item.placeholder
                cell.accessoryType = .disclosureIndicator
                return cell
            case .date:
                let cell = self.makeValue1TableCell()
                cell.imageView?.image = UIImage(named: "calendar.round.color")
                cell.textLabel?.text = item.placeholder
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
                cell.placeholderLabel.text = item.placeholder
                cell.textView.rx
                    .didChange
                    .flatMap({ [unowned cell] in cell.textView.rx.text.orEmpty })
                    .asDriver(onErrorJustReturn: "")
                    .map({ !$0.isEmpty })
                    .drive(cell.placeholderLabel.rx.isHidden)
                    .disposed(by: self.disposeBag)
                return cell
            case .label:
                let cell = self.makeSubtitleTableCell()
                cell.selectionStyle = .none
                cell.textLabel?.text = item.placeholder
                cell.accessoryType = .disclosureIndicator
                return cell
            case .location:
                let cell = self.makeSubtitleTableCell()
                cell.textLabel?.text = item.placeholder
                self.bindSelectedLocationViewModelToLocationLabel(relay: self.viewModel.selectedLocation,
                                                                  label: cell.detailTextLabel!)
                return cell
            case .time:
                let cell = self.makeValue1TableCell()
                cell.imageView?.image = UIImage(named: "clock.round.color")
                cell.textLabel?.text = item.placeholder
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
            default:
                let cell = self.makeHHTextFieldTableCell(with: item, style: .plain)
                cell.textField.autocapitalizationType = .words
                return cell
            }
        }
        return dataSource
    }
    
    private func makeHHTextFieldTableCell(with item: FieldDomain,
                                          style: HHTextFieldTableCellStyle) -> HHTextFieldTableCell {
        let cell = HHTextFieldTableCell(reuseIdentifier: HHTextFieldTableCell.identifier, style: style)
        cell.textField.placeholder = item.placeholder
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

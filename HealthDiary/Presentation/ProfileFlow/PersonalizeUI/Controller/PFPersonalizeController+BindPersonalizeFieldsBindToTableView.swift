//
//  PFPersonalizeController+BindPersonalizeFieldsBindToTableView.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 02/04/21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: BindPersonalizeFieldsBindToTableView
extension PFPersonalizeController {
    
    func bindPersonalizeFieldsToTableView(observables: Observable<[[PFPersonalizeFieldDomain]]>,
                                          tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        observables
            .observeOn(ConcurrentMainScheduler.instance)
            .map { (fields) -> [SectionModel<String, PFPersonalizeFieldDomain>] in
                let sections = fields.map { SectionModel(model: "", items: $0) }
                return sections
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, PFPersonalizeFieldDomain>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, PFPersonalizeFieldDomain>>
        { [unowned self] (_, _, _, item) -> UITableViewCell in
            switch item {
            case .dateOfBirth:
                let cell = self.makeHDTextFieldTableCell(with: item, style: .prompt)
                self.setupDateOfBirthHDTextFieldTableCell(cell, item: item)
                self.bindDateOfBirthToTextField(observable: self._dateOfBirth, textField: cell.textField)
                return cell
            case .firstName:
                let cell = self.makeHDTextFieldTableCell(with: item, style: .prompt)
                self.setupFirstNameHDTextFieldTableCell(cell, item: item)
                self.bindTextFieldToString(textField: cell.textField, subject: self._firstName)
                return cell
            case .gender:
                let cell = self.makeHDTextFieldTableCell(with: item, style: .prompt)
                self.setupGenderHDTextFieldTableCell(cell, item: item)
                self.bindGenderToTextField(subject: self._gender, textField: cell.textField)
                return cell
            case .lastName:
                let cell = self.makeHDTextFieldTableCell(with: item, style: .prompt)
                self.setupLastNameHDTextFieldTableCell(cell, item: item)
                self.bindTextFieldToString(textField: cell.textField, subject: self._lastName)
                return cell
            case .mobileNumber:
                let cell = self.makeHDTextFieldTableCell(with: item, style: .prompt)
                self.setupMobileNumberHDTextFieldTableCell(cell, item: item)
                self.bindCountryDialingCodeToTextFieldAndCountryDialingCodePicker(subject: self._countryDialingCode,
                                                                                  textField: cell.promptTextField,
                                                                                  picker: self.personalizeView.countryDialignCodePicker)
                self.bindMobileNumberTextFieldEditingChangedToMobileNumber(textField: cell.textField,
                                                                           subject: self._mobileNumbder)
                return cell
            case .photo:
                let cell = HDPhotoProfileTableCell()
                self.bindFullNameToHDPhotoProfileTableCell(observable: self._fullName, cell: cell)
                cell.addPhotoButton.rx.tap
                    .asDriver()
                    .filter({ [unowned self] in
                        return self.rxMediaPicker.deviceHasCamera
                    })
                    .drive(onNext: { [unowned self] in
                        
                    })
                    .disposed(by: self.disposeBag)
                return cell
            default:
                fatalError("PFPersonalizeController -> PFPersonalizeFieldDomain (\(item)) is not available")
            }
        }
        return dataSource
    }
    
}

extension PFPersonalizeController {
    
    func makeHDTextFieldTableCell(with item: PFPersonalizeFieldDomain,
                                  style: HDTextFieldTableCellStyle) -> HDTextFieldTableCell {
        let cell = HDTextFieldTableCell(reuseIdentifier: HDTextFieldTableCell.identifier, style: style)
        cell.textField.placeholder = item.placeholder
        return cell
    }
    
    func setupDateOfBirthHDTextFieldTableCell(_ cell: HDTextFieldTableCell, item: PFPersonalizeFieldDomain) {
        cell.promptTextField.text = item.placeholder
        cell.textField.inputView = self.personalizeView.dateOfBirthPicker
        cell.textField.clearButtonMode = .never
    }
    
    func setupFirstNameHDTextFieldTableCell(_ cell: HDTextFieldTableCell, item: PFPersonalizeFieldDomain) {
        cell.promptTextField.text = item.placeholder
        cell.textField.keyboardType = .alphabet
        cell.textField.autocapitalizationType = .words
    }
    
    func setupGenderHDTextFieldTableCell(_ cell: HDTextFieldTableCell, item: PFPersonalizeFieldDomain) {
        cell.promptTextField.text = item.placeholder
        cell.textField.inputView = self.personalizeView.genderPicker
        cell.textField.clearButtonMode = .never
    }
    
    func setupLastNameHDTextFieldTableCell(_ cell: HDTextFieldTableCell, item: PFPersonalizeFieldDomain) {
        cell.promptTextField.text = item.placeholder
        cell.textField.keyboardType = .alphabet
        cell.textField.autocapitalizationType = .words
    }
    
    func setupMobileNumberHDTextFieldTableCell(_ cell: HDTextFieldTableCell, item: PFPersonalizeFieldDomain) {
        cell.promptTextField.isEnabled = true
        cell.promptTextField.inputView = self.personalizeView.countryDialignCodePicker
        cell.textField.keyboardType = .numberPad
    }
    
}

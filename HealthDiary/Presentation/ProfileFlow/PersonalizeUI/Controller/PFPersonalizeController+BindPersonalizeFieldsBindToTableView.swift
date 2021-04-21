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
    
    func bindPersonalizeFieldsToTableView(observable: Observable<[[PFPLFieldDomain]]>,
                                          tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        observable
            .observeOn(ConcurrentMainScheduler.instance)
            .map { $0.map { SectionModel(model: "", items: $0) } }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, PFPLFieldDomain>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, PFPLFieldDomain>>
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
                self.bindTextFieldToFirstOrLastName(textField: cell.textField, subject: self._firstName)
                return cell
            case .gender:
                let cell = self.makeHDTextFieldTableCell(with: item, style: .prompt)
                self.setupGenderHDTextFieldTableCell(cell, item: item)
                self.bindGenderToTextField(subject: self._gender, textField: cell.textField)
                return cell
            case .lastName:
                let cell = self.makeHDTextFieldTableCell(with: item, style: .prompt)
                self.setupLastNameHDTextFieldTableCell(cell, item: item)
                self.bindTextFieldToFirstOrLastName(textField: cell.textField, subject: self._lastName)
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
                self.bindFirstOrLastNameOrPhotoToHDPhotoProfileTableCell(observable: self._firstOrLastNameOrPhoto,
                                                                         cell: cell)
                self.bindAddPhotoButtonToPhoto(button: cell.addPhotoButton, subject: self._photo)
                self.bindPhotoToPhotoImageView(observable: self._photo, imageView: cell.photoImageView)
                return cell
            default:
                fatalError("PFPersonalizeController -> PFPLFieldDomain (\(item)) is not available")
            }
        }
        return dataSource
    }
    
}

extension PFPersonalizeController {
    
    func makeHDTextFieldTableCell(with item: PFPLFieldDomain,
                                  style: HDTextFieldTableCellStyle) -> HDTextFieldTableCell {
        let cell = HDTextFieldTableCell(reuseIdentifier: HDTextFieldTableCell.identifier, style: style)
        cell.textField.placeholder = item.placeholder
        return cell
    }
    
    func setupDateOfBirthHDTextFieldTableCell(_ cell: HDTextFieldTableCell, item: PFPLFieldDomain) {
        cell.promptTextField.text = item.placeholder
        cell.textField.inputView = self.personalizeView.dateOfBirthPicker
        cell.textField.clearButtonMode = .never
    }
    
    func setupFirstNameHDTextFieldTableCell(_ cell: HDTextFieldTableCell, item: PFPLFieldDomain) {
        cell.promptTextField.text = item.placeholder
        cell.textField.keyboardType = .alphabet
        cell.textField.autocapitalizationType = .words
    }
    
    func setupGenderHDTextFieldTableCell(_ cell: HDTextFieldTableCell, item: PFPLFieldDomain) {
        cell.promptTextField.text = item.placeholder
        cell.textField.inputView = self.personalizeView.genderPicker
        cell.textField.clearButtonMode = .never
    }
    
    func setupLastNameHDTextFieldTableCell(_ cell: HDTextFieldTableCell, item: PFPLFieldDomain) {
        cell.promptTextField.text = item.placeholder
        cell.textField.keyboardType = .alphabet
        cell.textField.autocapitalizationType = .words
    }
    
    func setupMobileNumberHDTextFieldTableCell(_ cell: HDTextFieldTableCell, item: PFPLFieldDomain) {
        cell.promptTextField.isEnabled = true
        cell.promptTextField.inputView = self.personalizeView.countryDialignCodePicker
        cell.textField.keyboardType = .numberPad
    }
    
}

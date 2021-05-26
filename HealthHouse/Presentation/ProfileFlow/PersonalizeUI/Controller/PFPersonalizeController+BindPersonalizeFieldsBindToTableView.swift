//
//  PFPersonalizeController+BindPersonalizeFieldsBindToTableView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/04/21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: BindPersonalizeFieldsBindToTableView
extension PFPersonalizeController {
    
    func bindSectionsToTableView(sections: Observable<[[RowDomain]]>, tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        sections
            .observe(on: ConcurrentMainScheduler.instance)
            .map({ $0.map { SectionModel(model: "", items: $0) } })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, RowDomain>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, RowDomain>>
        { [unowned self] (_, _, _, item) -> UITableViewCell in
            switch item {
            case .dateOfBirth:
                let cell = self.makeHHTextFieldTableCell(with: item, style: .prompt)
                self.setupDateOfBirthHHTextFieldTableCell(cell, item: item)
                self.bindDateOfBirthToTextField(dateOfBirth: self._dateOfBirth, textField: cell.textField)
                return cell
            case .firstName:
                let cell = self.makeHHTextFieldTableCell(with: item, style: .prompt)
                self.setupFirstOrLastNameHHTextFieldTableCell(cell, item: item)
                self.bindTextFieldToFirstOrLastName(textField: cell.textField, firstOrLastName: self._firstName)
                return cell
            case .gender:
                let cell = self.makeHHTextFieldTableCell(with: item, style: .prompt)
                self.setupGenderHHTextFieldTableCell(cell, item: item)
                self.bindGenderToTextField(gender: self._gender, textField: cell.textField)
                return cell
            case .lastName:
                let cell = self.makeHHTextFieldTableCell(with: item, style: .prompt)
                self.setupFirstOrLastNameHHTextFieldTableCell(cell, item: item)
                self.bindTextFieldToFirstOrLastName(textField: cell.textField, firstOrLastName: self._lastName)
                return cell
            case .mobileNumber:
                let cell = self.makeHHTextFieldTableCell(with: item, style: .prompt)
                self.setupMobileNumberHHTextFieldTableCell(cell, item: item)
                self.bindCountryDialingCodeToTextFieldAndCountryDialingCodePicker(countryDialingCode: self._countryDialingCode,
                                                                                  textField: cell.promptTextField,
                                                                                  picker: self._view.countryDialignCodePicker)
                self.bindMobileNumberTextFieldEditingChangedToMobileNumber(textField: cell.textField,
                                                                           mobileNumber: self._mobileNumbder)
                return cell
            case .photo:
                let cell = HHPhotoProfileTableCell()
                self.bindFirstOrLastNameOrPhotoToHDPhotoProfileTableCell(observable: self._firstOrLastNameOrPhoto,
                                                                         cell: cell)
                self.bindAddPhotoButtonToPhoto(button: cell.addPhotoButton, photo: self._photo)
                self.bindPhotoToPhotoImageView(photo: self._photo, imageView: cell.photoImageView)
                return cell
            default:
                fatalError("PFPersonalizeController -> FieldDomain (\(item)) is not available")
            }
        }
        return dataSource
    }
    
}

extension PFPersonalizeController {
    
    func makeHHTextFieldTableCell(with item: RowDomain,
                                  style: HHTextFieldTableCellStyle) -> HHTextFieldTableCell {
        let cell = HHTextFieldTableCell(reuseIdentifier: HHTextFieldTableCell.identifier, style: style)
        cell.textField.placeholder = item.identify
        return cell
    }
    
    func setupDateOfBirthHHTextFieldTableCell(_ cell: HHTextFieldTableCell, item: RowDomain) {
        cell.promptTextField.text = item.identify
        cell.textField.inputView = self._view.dateOfBirthPicker
        cell.textField.clearButtonMode = .never
    }
    
    func setupFirstOrLastNameHHTextFieldTableCell(_ cell: HHTextFieldTableCell, item: RowDomain) {
        cell.promptTextField.text = item.identify
        cell.textField.keyboardType = .alphabet
        cell.textField.autocapitalizationType = .words
    }
    
    func setupGenderHHTextFieldTableCell(_ cell: HHTextFieldTableCell, item: RowDomain) {
        cell.promptTextField.text = item.identify
        cell.textField.inputView = self._view.genderPicker
        cell.textField.clearButtonMode = .never
    }
    
    func setupMobileNumberHHTextFieldTableCell(_ cell: HHTextFieldTableCell, item: RowDomain) {
        cell.promptTextField.isEnabled = true
        cell.promptTextField.inputView = self._view.countryDialignCodePicker
        cell.textField.keyboardType = .numberPad
    }
    
}

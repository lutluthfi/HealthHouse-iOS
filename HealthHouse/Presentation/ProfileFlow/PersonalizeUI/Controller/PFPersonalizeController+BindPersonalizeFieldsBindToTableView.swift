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
    
    func bind(sections: Observable<[[RowDomain]]>, toTableView tableView: UITableView) {
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
                self.bind(dateOfBirth: self._dateOfBirth, toTextFieldInCell: cell.textField)
                return cell
            case .firstName:
                let cell = self.makeHHTextFieldTableCell(with: item, style: .prompt)
                self.setupFirstOrLastNameHHTextFieldTableCell(cell, item: item)
                self.bind(textFieldInCell: cell.textField, toFirstOrLastName: self._firstName)
                return cell
            case .gender:
                let cell = self.makeHHTextFieldTableCell(with: item, style: .prompt)
                self.setupGenderHHTextFieldTableCell(cell, item: item)
                self.bind(gender: self._gender, toTextFieldInCell: cell.textField)
                return cell
            case .lastName:
                let cell = self.makeHHTextFieldTableCell(with: item, style: .prompt)
                self.setupFirstOrLastNameHHTextFieldTableCell(cell, item: item)
                self.bind(textFieldInCell: cell.textField, toFirstOrLastName: self._lastName)
                return cell
            case .mobileNumber:
                let cell = self.makeHHTextFieldTableCell(with: item, style: .prompt)
                self.setupMobileNumberHHTextFieldTableCell(cell, item: item)
                self.bind(countryDialingCode: self._countryDialingCode,
                          toPromptTextFieldInCell: cell.promptTextField,
                          toCountryDialingCodePicker: self._view.countryDialignCodePicker)
                self.bind(mobileNumerTextFieldEditingChangedInCell: cell.textField,
                          toMobileNumber: self._mobileNumbder)
                return cell
            case .photo:
                let cell = PhotoProfileTableCell()
                self.bind(firstOrLastNameOrPhoto: self._firstOrLastNameOrPhoto,
                          toPhotoProfileTableCell: cell)
                self.bind(addPhotoButtonTapInCell: cell.addPhotoButton, addPhotoButtonTap: self._photo)
                self.bind(photo: self._photo, toPhotoImageViewInCell: cell.photoImageView)
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
                                  style: HHTextFieldTableCellStyle) -> TextFieldTableCell {
        let cell = TextFieldTableCell(reuseIdentifier: TextFieldTableCell.identifier, style: style)
        cell.textField.placeholder = item.identify
        return cell
    }
    
    func setupDateOfBirthHHTextFieldTableCell(_ cell: TextFieldTableCell, item: RowDomain) {
        cell.promptTextField.text = item.identify
        cell.textField.inputView = self._view.dateOfBirthPicker
        cell.textField.clearButtonMode = .never
    }
    
    func setupFirstOrLastNameHHTextFieldTableCell(_ cell: TextFieldTableCell, item: RowDomain) {
        cell.promptTextField.text = item.identify
        cell.textField.keyboardType = .alphabet
        cell.textField.autocapitalizationType = .words
    }
    
    func setupGenderHHTextFieldTableCell(_ cell: TextFieldTableCell, item: RowDomain) {
        cell.promptTextField.text = item.identify
        cell.textField.inputView = self._view.genderPicker
        cell.textField.clearButtonMode = .never
    }
    
    func setupMobileNumberHHTextFieldTableCell(_ cell: TextFieldTableCell, item: RowDomain) {
        cell.promptTextField.isEnabled = true
        cell.promptTextField.inputView = self._view.countryDialignCodePicker
        cell.textField.keyboardType = .numberPad
    }
    
}

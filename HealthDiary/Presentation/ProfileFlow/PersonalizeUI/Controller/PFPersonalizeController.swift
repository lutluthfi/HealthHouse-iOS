//
//  PFPersonalizeController.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxCocoa
import RxDataSources
import RxGesture
import RxKeyboard
import RxSwift
import UIKit

fileprivate extension Int {
    
    static let longestMobileNumber = Int(15)
    static let shortestMobileNumber = Int(7)
    
}

fileprivate extension String {
    
    var isFirstNameValid: Bool {
        return !self.isEmpty
    }
    var isMobileNumberValid: Bool {
        return (.shortestMobileNumber)...(.longestMobileNumber) ~= self.count
    }
    
}

// MARK: PFPersonalizeController
final class PFPersonalizeController: UIViewController {
    
    // MARK: DI Variable
    let disposeBag = DisposeBag()
    lazy var rxMediaPicker = RxMediaPicker(delegate: self)
    lazy var personalizeView: PFPersonalizeView = DefaultPFPersonalizeView()
    lazy var _view: UIView = (self.personalizeView as! UIView)
    var viewModel: PFPersonalizeViewModel!
    
    // MARK: Common Variable
    var countryDialingCodes: [CountryDialingCodeDomain] = []
    var _countryDialingCode = BehaviorSubject<CountryDialingCodeDomain>(value: .indonesia)
    var _dateOfBirth = BehaviorSubject<Date?>(value: nil)
    var _firstName = BehaviorSubject<String?>(value: nil)
    var _gender = BehaviorSubject<GenderDomain?>(value: nil)
    var _lastName = BehaviorSubject<String?>(value: nil)
    var _mobileNumbder = BehaviorSubject<String?>(value: nil)
    lazy var _fieldValues: Observable<(Date?, String?, GenderDomain?, String?, String?)> = {
        return Observable.combineLatest(self._dateOfBirth,
                                        self._firstName,
                                        self._gender,
                                        self._lastName,
                                        self._mobileNumbder)
    }()
    lazy var _fullName: Observable<(String?, String?)> = {
        return Observable.combineLatest(self._firstName, self._lastName)
    }()
    
    // MARK: Create Function
    class func create(with viewModel: PFPersonalizeViewModel) -> PFPersonalizeController {
        let controller = PFPersonalizeController()
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: UIViewController Function
    override func loadView() {
        self.view = self._view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(view: self.personalizeView, viewModel: self.viewModel)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.personalizeView.viewWillAppear(navigationController: self.navigationController,
                                            navigationItem: self.navigationItem,
                                            tabBarController: self.tabBarController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.personalizeView.viewWillDisappear()
    }
    
    // MARK: Bind View Function
    private func bind(view: PFPersonalizeView, viewModel: PFPersonalizeViewModel) {
        self._view.bindTapGestureForEndEditing(disposeBag: self.disposeBag)
        view.tableView.bindKeyboardHeight(disposeBag: self.disposeBag)
        self.bindShowedCountryDialingCodeToCountryDialingCodes(observable: viewModel.showedCountryDialingCodes)
        self.bindShowedCountryDialingCodeToCountryDialingCodePicker(observable: viewModel.showedCountryDialingCodes,
                                                                    picker: view.countryDialignCodePicker)
        self.bindTableViewDelegate(tableView: view.tableView)
        self.bindFieldValuesToBarButtonItemEnabled(fieldValues: self._fieldValues,
                                                   barButtonItem: view.createBarButtonItem)
        self.bindCreateBarButtonItemTapToFieldValuesAndViewModel(barButtonItem: view.createBarButtonItem,
                                                                 fieldValues: self._fieldValues,
                                                                 viewModel: viewModel)
        self.bindDatePickerToDateOfBirth(datePicker: view.dateOfBirthPicker, subject: self._dateOfBirth)
        self.bindGenderToPicker(picker: view.genderPicker)
        self.bindGenderPickerToSubject(picker: view.genderPicker, subject: self._gender)
        self.bindCountryDialingCodePickerToSubject(picker: view.countryDialignCodePicker,
                                                   subject: self._countryDialingCode)
        self.bindPersonalizeFieldsToTableView(observables: Observable.just(view.personalizeFields),
                                              tableView: view.tableView)
    }
    
}

// MARK: BindCountryDialingCodePickerToSubject
extension PFPersonalizeController {
    
    func bindCountryDialingCodePickerToSubject(picker: UIPickerView,
                                               subject: BehaviorSubject<CountryDialingCodeDomain>) {
        picker.rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self, unowned subject] (row, component) in
                subject.onNext(self.countryDialingCodes[row])
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCountryDialingCodePickerToTextField
extension PFPersonalizeController {
    
    func bindCountryDialingCodeToTextFieldAndCountryDialingCodePicker(subject: BehaviorSubject<CountryDialingCodeDomain>,
                                                                            textField: UITextField,
                                                                            picker: UIPickerView) {
        subject
            .asDriver(onErrorJustReturn: .indonesia)
            .drive(onNext: { [unowned self] (countryDialingCode) in
                let row = self.countryDialingCodes.row(of: countryDialingCode) ?? 0
                picker.selectRow(row, inComponent: 0, animated: true)
                textField.text = countryDialingCode.dialCode
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCreateBarButtonItemTap
extension PFPersonalizeController {
    
    func bindCreateBarButtonItemTapToFieldValuesAndViewModel(barButtonItem: UIBarButtonItem,
                                                             fieldValues: Observable<(Date?, String?, GenderDomain?, String?, String?)>,
                                                             viewModel: PFPersonalizeViewModel) {
        barButtonItem.rx.tap
            .flatMap { [unowned fieldValues] in fieldValues }
            .bind(onNext: { (fieldValues) in
                viewModel.doCreate(firstName: fieldValues.1,
                                   lastName: fieldValues.3,
                                   dateOfBirth: fieldValues.0,
                                   gender: fieldValues.2,
                                   mobileNumber: fieldValues.4)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindDateOfBirthToTextField
extension PFPersonalizeController {
    
    func bindDateOfBirthToTextField(observable: Observable<Date?>, textField: UITextField) {
        observable.asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [unowned textField] (dateOfBirth) in
                textField.text = dateOfBirth?.formatted(components: [.dayOfWeekWideName,
                                                                     .comma,
                                                                     .whitespace,
                                                                     .dayOfMonthPadding,
                                                                     .whitespace,
                                                                     .monthOfYearFullName,
                                                                     .whitespace,
                                                                     .yearFullDigits])
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindDatePickerToTextFieldAndSubject
extension PFPersonalizeController {
    
    func bindDatePickerToDateOfBirth(datePicker: UIDatePicker, subject: BehaviorSubject<Date?>) {
        datePicker.rx.date
            .asDriver()
            .drive(onNext: { [unowned subject] in
                subject.onNext($0)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindFieldValuesToBarButtonItemEnabled
extension PFPersonalizeController {
    
    func bindFieldValuesToBarButtonItemEnabled(fieldValues: Observable<(Date?, String?, GenderDomain?, String?, String?)>,
                                               barButtonItem: UIBarButtonItem) {
        fieldValues
            .observeOn(ConcurrentMainScheduler.instance)
            .map { (dateOfBirth, firstName, gender, _, mobileNumber) -> Bool in
                let isDateOfBirthNotNil = dateOfBirth != nil
                let isFirstNameValid = firstName?.isFirstNameValid == true
                let isGenderNotNil = gender != nil
                let isMobileNumberValid = mobileNumber?.isMobileNumberValid == true
                return isDateOfBirthNotNil && isFirstNameValid && isGenderNotNil && isMobileNumberValid
            }
            .asDriver(onErrorJustReturn: false)
            .drive(barButtonItem.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindGenderToPicker
extension PFPersonalizeController {
    
    func bindGenderToPicker(picker: UIPickerView) {
        Observable<[GenderDomain]>.just(GenderDomain.allCases)
            .bind(to: picker.rx.itemTitles) { (_, item) -> String? in
                return item.rawValue.capitalized
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindGenderPickerToGender
extension PFPersonalizeController {
    
    func bindGenderPickerToSubject(picker: UIPickerView, subject: BehaviorSubject<GenderDomain?>) {
        picker.rx.itemSelected
            .asDriver()
            .drive(onNext: { (row, _) in
                subject.onNext(GenderDomain.allCases[row])
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindGenderToTextField
extension PFPersonalizeController {
    
    func bindGenderToTextField(subject: BehaviorSubject<GenderDomain?>, textField: UITextField) {
        subject
            .asDriver(onErrorJustReturn: .male)
            .map({ $0?.rawValue.capitalized })
            .drive(textField.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindMobileNumberTextFieldEditingChanged
extension PFPersonalizeController {
    
    func bindMobileNumberTextFieldEditingChangedToMobileNumber(textField: UITextField, subject: BehaviorSubject<String?>) {
        textField.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned textField, unowned subject] in
                let text = textField.text!
                textField.text = String(text.prefix(15))
                if text.first == "0" {
                    textField.text = ""
                }
                subject.onNext(textField.text!)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: BindShowedCountryDialingCodeToCountryDialingCodes
extension PFPersonalizeController {
    
    func bindShowedCountryDialingCodeToCountryDialingCodes(observable: Observable<[CountryDialingCodeDomain]>) {
        observable
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] in
                self.countryDialingCodes = $0
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindShowedCountryDialingCodeToCountryDialingCodePicker
extension PFPersonalizeController {
    
    func bindShowedCountryDialingCodeToCountryDialingCodePicker(observable: Observable<[CountryDialingCodeDomain]>,
                                                                picker: UIPickerView) {
        observable
            .asDriver(onErrorJustReturn: [])
            .drive(picker.rx.itemTitles) {
                return "\($1.code) (\($1.flag)) \($1.dialCode)"
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTextFieldToFirstName
extension PFPersonalizeController {
    
    func bindTextFieldToFirstName(textField: UITextField, subject: BehaviorSubject<String?>) {
        textField.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned textField, unowned subject] in
                let text = textField.text!
                subject.onNext(text)
            })
            .disposed(by: self.disposeBag)
    }
    
}


// MARK: BindTextFieldToString
extension PFPersonalizeController {
    
    func bindTextFieldToString(textField: UITextField, subject: BehaviorSubject<String?>) {
        textField.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned textField, unowned subject] in
                let text = textField.text!
                subject.onNext(text)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindFirstNameToHDPhotoProfileTableCell
extension PFPersonalizeController {
    
    func bindFullNameToHDPhotoProfileTableCell(observable: Observable<(String?, String?)>,
                                               cell: HDPhotoProfileTableCell) {
        observable.asDriver(onErrorJustReturn: ("", ""))
            .drive(onNext: { [unowned cell] (fullName) in
                let firstNameCharacter = fullName.0?.first?.uppercased() ?? ""
                let lastNameCharacter = fullName.1?.first?.uppercased() ?? ""
                let abbreviationName = firstNameCharacter + lastNameCharacter
                cell.abbreviationName = abbreviationName
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: RxMediaPickerDelegate
extension PFPersonalizeController: RxMediaPickerDelegate {
}

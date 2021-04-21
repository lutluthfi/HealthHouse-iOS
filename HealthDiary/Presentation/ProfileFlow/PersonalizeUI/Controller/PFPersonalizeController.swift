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
    
    var isFirstOrLastNameValid: Bool {
        return !self.isEmpty && !self.contains([.number, .specialCharacter])
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
    var viewModel: PFPersonalizeViewModel!
    lazy var _view: UIView = (self.personalizeView as! UIView)
    
    // MARK: Common Variable
    var countryDialingCodes: [CountryDialingCodeDomain] = []
    var _countryDialingCode = BehaviorSubject<CountryDialingCodeDomain>(value: .indonesia)
    var _dateOfBirth = BehaviorSubject<Date>(value: Date())
    var _firstName = BehaviorSubject<String>(value: "")
    var _gender = BehaviorSubject<GenderDomain>(value: .male)
    var _lastName = BehaviorSubject<String>(value: "")
    var _mobileNumbder = BehaviorSubject<String>(value: "")
    var _photo = BehaviorSubject<UIImage?>(value: nil)
    lazy var _fieldValues: Observable<(Date, String, GenderDomain, String, String, UIImage?)> = {
        return Observable.combineLatest(self._dateOfBirth,
                                        self._firstName,
                                        self._gender,
                                        self._lastName,
                                        self._mobileNumbder,
                                        self._photo)
    }()
    lazy var _firstOrLastNameOrPhoto: Observable<(String, String, UIImage?)> = {
        return Observable.combineLatest(self._firstName, self._lastName, self._photo)
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
        self.bindViewModelResponse(observable: viewModel.response)
        self.bindShowedCountryDialingCodeToCountryDialingCodes(observable: viewModel.showedCountryDialingCodes)
        self.bindShowedCountryDialingCodeToCountryDialingCodePicker(observable: viewModel.showedCountryDialingCodes,
                                                                    picker: view.countryDialignCodePicker)
        self.bindTableViewDelegate(tableView: view.tableView)
        self.bindFieldValuesToBarButtonItemEnabled(observable: self._fieldValues,
                                                   barButtonItem: view.createBarButtonItem)
        self.bindCreateBarButtonItemTapToFieldValuesAndViewModel(barButtonItem: view.createBarButtonItem,
                                                                 observable: self._fieldValues,
                                                                 viewModel: viewModel)
        self.bindDatePickerToDateOfBirth(datePicker: view.dateOfBirthPicker, subject: self._dateOfBirth)
        self.bindGenderToPicker(picker: view.genderPicker)
        self.bindGenderPickerToSubject(picker: view.genderPicker, subject: self._gender)
        self.bindCountryDialingCodePickerToSubject(picker: view.countryDialignCodePicker,
                                                   subject: self._countryDialingCode)
        self.bindPersonalizeFieldsToTableView(observable: Observable.just(view.personalizeFields),
                                              tableView: view.tableView)
    }
    
}

// MARK: BindAddPhotoButtonToPhoto
extension PFPersonalizeController {
    
    func bindAddPhotoButtonToPhoto(button: UIButton, subject: BehaviorSubject<UIImage?>) {
        button.rx.tap
            .flatMap { [unowned self] (_) -> Observable<(UIImage, UIImage?)> in
                self.rxMediaPicker.selectImage(source: .photoLibrary, editable: true)
            }
            .map { $0.0 }
            .bind(to: subject)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCountryDialingCodePickerToSubject
extension PFPersonalizeController {
    
    func bindCountryDialingCodePickerToSubject(picker: UIPickerView,
                                               subject: BehaviorSubject<CountryDialingCodeDomain>) {
        picker.rx
            .itemSelected
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
                                                             observable: Observable<(Date, String, GenderDomain, String, String, UIImage?)>,
                                                             viewModel: PFPersonalizeViewModel) {
        barButtonItem.rx.tap
            .flatMap { [unowned observable] in observable }
            .bind(onNext: { [unowned viewModel] (observable) in
                viewModel.doCreate(firstName: observable.1,
                                   dateOfBirth: observable.0,
                                   gender: observable.2,
                                   lastName: observable.3,
                                   mobileNumber: observable.4,
                                   photo: observable.5)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindDateOfBirthToTextField
extension PFPersonalizeController {
    
    func bindDateOfBirthToTextField(observable: Observable<Date>, textField: UITextField) {
        observable
            .asDriver(onErrorJustReturn: Date())
            .drive(onNext: { [unowned textField] (dateOfBirth) in
                textField.text = dateOfBirth.formatted(components: [.dayOfWeekWideName,
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
    
    func bindDatePickerToDateOfBirth(datePicker: UIDatePicker, subject: BehaviorSubject<Date>) {
        datePicker.rx.date
            .asDriver()
            .drive(subject)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindFieldValuesToBarButtonItemEnabled
extension PFPersonalizeController {
    
    func bindFieldValuesToBarButtonItemEnabled(observable: Observable<(Date, String, GenderDomain, String, String, UIImage?)>,
                                               barButtonItem: UIBarButtonItem) {
        observable
            .observeOn(ConcurrentMainScheduler.instance)
            .map { (_, firstName, _, _, mobileNumber, _) -> Bool in
                let isFirstNameValid = firstName.isFirstOrLastNameValid
                let isMobileNumberValid = mobileNumber.isMobileNumberValid
                return isFirstNameValid && isMobileNumberValid
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
    
    func bindGenderPickerToSubject(picker: UIPickerView, subject: BehaviorSubject<GenderDomain>) {
        picker.rx
            .itemSelected
            .asDriver()
            .drive(onNext: { (row, _) in
                subject.onNext(GenderDomain.allCases[row])
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindGenderToTextField
extension PFPersonalizeController {
    
    func bindGenderToTextField(subject: BehaviorSubject<GenderDomain>, textField: UITextField) {
        subject
            .asDriver(onErrorJustReturn: .male)
            .map({ $0.rawValue.capitalized })
            .drive(textField.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindMobileNumberTextFieldEditingChanged
extension PFPersonalizeController {
    
    func bindMobileNumberTextFieldEditingChangedToMobileNumber(textField: UITextField,
                                                               subject: BehaviorSubject<String>) {
        textField.rx
            .controlEvent(.editingChanged)
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

// MARK: BindPhotoToPhotoImageView
extension PFPersonalizeController {
    
    func bindPhotoToPhotoImageView(observable: Observable<UIImage?>, imageView: UIImageView) {
        observable
            .asDriver(onErrorJustReturn: nil)
            .drive(imageView.rx.image)
            .disposed(by: self.disposeBag)
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


// MARK: BindTextFieldToString
extension PFPersonalizeController {
    
    func bindTextFieldToFirstOrLastName(textField: UITextField, subject: BehaviorSubject<String>) {
        textField.rx
            .controlEvent(.editingChanged)
            .map({ [unowned textField] () -> String in
                return textField.text!
            })
            .filter({ $0.isFirstOrLastNameValid })
            .asDriver(onErrorJustReturn: "")
            .drive(subject)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindFirstNameToHDPhotoProfileTableCell
extension PFPersonalizeController {
    
    func bindFirstOrLastNameOrPhotoToHDPhotoProfileTableCell(observable: Observable<(String, String, UIImage?)>,
                                                             cell: HDPhotoProfileTableCell) {
        observable
            .asDriver(onErrorJustReturn: ("", "", nil))
            .drive(onNext: { [unowned cell] (observable) in
                if let photoImage = observable.2 {
                    cell.photoImage = photoImage
                } else {
                    let firstNameCharacter = observable.0.first?.uppercased() ?? ""
                    let lastNameCharacter = observable.1.first?.uppercased() ?? ""
                    let abbreviationName = firstNameCharacter + lastNameCharacter
                    cell.abbreviationName = abbreviationName
                }
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindViewModelResponse
extension PFPersonalizeController {
    
    func bindViewModelResponse(observable: Observable<PFPersonalizeViewModelResponse>) {
        observable
            .subscribeOn(MainScheduler.instance)
            .bind(onNext: self.onNext(_:))
            .disposed(by: self.disposeBag)
    }
    
    private func onNext(_ response: PFPersonalizeViewModelResponse) {
        switch response {
        case .DoCreate(let result):
            self.onNextDoCreate(result)
        }
    }
    
    private func onNextDoCreate(_ result: AnyResult<String, String>) {
        switch result {
        case .success(let message):
            let continueAction = UIAlertAction(title: "Continue", style: .default) { (_) in
                
            }
            self.showAlert(title: "Congratulations 🎉", message: message, actions: [continueAction])
        case .failure(let message):
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            self.showAlert(title: "Failure 😕", message: message, actions: [dismissAction])
        }
    }
    
}

// MARK: RxMediaPickerDelegate
extension PFPersonalizeController: RxMediaPickerDelegate {
}

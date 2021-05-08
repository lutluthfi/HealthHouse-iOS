//
//  PFPersonalizeController.swift
//  HealthHouse
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
    var _countryDialingCode = BehaviorRelay<CountryDialingCodeDomain>(value: .indonesia)
    var _dateOfBirth = BehaviorRelay<Date>(value: Date())
    var _firstName = BehaviorRelay<String>(value: "")
    var _gender = BehaviorRelay<GenderDomain>(value: .male)
    var _lastName = BehaviorRelay<String>(value: "")
    var _mobileNumbder = BehaviorRelay<String>(value: "")
    var _photo = BehaviorRelay<UIImage?>(value: nil)
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
        self.bindTableViewDelegate(tableView: self.personalizeView.tableView)
        self.view = self._view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._view.bindTapGestureForEndEditing(disposeBag: self.disposeBag)
        self.personalizeView.tableView.bindKeyboardHeight(disposeBag: self.disposeBag)
        self.bindViewModelResult(observable: self.viewModel.result)
        self.bindShowedCountryDialingCodeToCountryDialingCodes(observable: self.viewModel.showedCountryDialingCodes)
        self.bindShowedCountryDialingCodeToCountryDialingCodePicker(observable: self.viewModel.showedCountryDialingCodes,
                                                                    picker: self.personalizeView.countryDialignCodePicker)
        self.bindFieldValuesToBarButtonItemEnabled(observable: self._fieldValues,
                                                   barButtonItem: self.personalizeView.createBarButtonItem)
        self.bindCreateBarButtonItemTapToFieldValues(barButtonItem: self.personalizeView.createBarButtonItem,
                                                     observable: self._fieldValues)
        self.bindDatePickerToDateOfBirth(datePicker: self.personalizeView.dateOfBirthPicker,
                                         relay: self._dateOfBirth)
        self.bindGenderToPicker(picker: self.personalizeView.genderPicker)
        self.bindGenderPickerToGender(picker: self.personalizeView.genderPicker, relay: self._gender)
        self.bindCountryDialingCodePickerToCountryDialingCode(picker: self.personalizeView.countryDialignCodePicker,
                                                              relay: self._countryDialingCode)
        self.bindFieldsToTableView(observable: Observable.just(self.personalizeView.fields),
                                   tableView: self.personalizeView.tableView)
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
    
}

// MARK: BindAddPhotoButtonToPhoto
extension PFPersonalizeController {
    
    func bindAddPhotoButtonToPhoto(button: UIButton, relay: BehaviorRelay<UIImage?>) {
        button.rx.tap
            .flatMap { [unowned self] (_) -> Observable<(UIImage, UIImage?)> in
                self.rxMediaPicker.selectImage(source: .photoLibrary, editable: true)
            }
            .map({ $0.0 })
            .bind(to: relay)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCountryDialingCodePickerToSubject
extension PFPersonalizeController {
    
    func bindCountryDialingCodePickerToCountryDialingCode(picker: UIPickerView,
                                                          relay: BehaviorRelay<CountryDialingCodeDomain>) {
        picker.rx
            .itemSelected
            .asDriver()
            .drive(onNext: { [unowned self, unowned relay] (row, component) in
                relay.accept(self.countryDialingCodes[row])
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCountryDialingCodePickerToTextField
extension PFPersonalizeController {
    
    func bindCountryDialingCodeToTextFieldAndCountryDialingCodePicker(relay: BehaviorRelay<CountryDialingCodeDomain>,
                                                                      textField: UITextField,
                                                                      picker: UIPickerView) {
        relay
            .asDriver(onErrorJustReturn: .indonesia)
            .drive(onNext: { [unowned self] (countryDialingCode) in
                let row = self.countryDialingCodes.row(of: countryDialingCode) ?? 0
                picker.selectRow(row, inComponent: 0, animated: true)
                textField.text = countryDialingCode.dialCode
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCreateBarButtonItemTapToFieldValues
extension PFPersonalizeController {
    
    func bindCreateBarButtonItemTapToFieldValues(barButtonItem: UIBarButtonItem,
                                                 observable: Observable<(Date,
                                                                         String,
                                                                         GenderDomain,
                                                                         String,
                                                                         String,
                                                                         UIImage?)>) {
        barButtonItem.rx.tap
            .flatMap { [unowned observable] in observable }
            .bind(onNext: { [unowned self] (observable) in
                self.viewModel.doCreate(firstName: observable.1,
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
    
    func bindDateOfBirthToTextField(observable: BehaviorRelay<Date>, textField: UITextField) {
        observable
            .asDriver(onErrorJustReturn: Date())
            .map({ $0.formatted(components: [.dayOfWeekWideName,
                                             .comma,
                                             .whitespace,
                                             .dayOfMonthPadding,
                                             .whitespace,
                                             .monthOfYearFullName,
                                             .whitespace,
                                             .yearFullDigits])
            })
            .drive(textField.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindDatePickerToTextFieldAndSubject
extension PFPersonalizeController {
    
    func bindDatePickerToDateOfBirth(datePicker: UIDatePicker, relay: BehaviorRelay<Date>) {
        datePicker.rx.date
            .asDriver()
            .drive(relay)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindFieldValuesToBarButtonItemEnabled
extension PFPersonalizeController {
    
    func bindFieldValuesToBarButtonItemEnabled(observable: Observable<(Date, String, GenderDomain, String, String, UIImage?)>,
                                               barButtonItem: UIBarButtonItem) {
        observable
            .observe(on: ConcurrentMainScheduler.instance)
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
    
    func bindGenderPickerToGender(picker: UIPickerView, relay: BehaviorRelay<GenderDomain>) {
        picker.rx
            .itemSelected
            .asDriver()
            .drive(onNext: { [unowned relay] (row, _) in
                relay.accept(GenderDomain.allCases[row])
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindGenderToTextField
extension PFPersonalizeController {
    
    func bindGenderToTextField(relay: BehaviorRelay<GenderDomain>, textField: UITextField) {
        relay
            .asDriver(onErrorJustReturn: .male)
            .map({ $0.rawValue.capitalized })
            .drive(textField.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindMobileNumberTextFieldEditingChanged
extension PFPersonalizeController {
    
    func bindMobileNumberTextFieldEditingChangedToMobileNumber(textField: UITextField,
                                                               relay: BehaviorRelay<String>) {
        textField.rx
            .controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned textField, unowned relay] in
                let text = textField.text!
                textField.text = String(text.prefix(15))
                if text.first == "0" {
                    textField.text = ""
                }
                relay.accept(textField.text!)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: BindPhotoToPhotoImageView
extension PFPersonalizeController {
    
    func bindPhotoToPhotoImageView(relay: BehaviorRelay<UIImage?>, imageView: UIImageView) {
        relay
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
    
    func bindTextFieldToFirstOrLastName(textField: UITextField, relay: BehaviorRelay<String>) {
        textField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(textField.rx.text)
            .filter({ $0?.isFirstOrLastNameValid == true })
            .asDriver(onErrorJustReturn: "")
            .drive(with: relay)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindFirstNameToHDPhotoProfileTableCell
extension PFPersonalizeController {
    
    func bindFirstOrLastNameOrPhotoToHDPhotoProfileTableCell(observable: Observable<(String, String, UIImage?)>,
                                                             cell: HHPhotoProfileTableCell) {
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
    
    func bindViewModelResult(observable: Observable<PFPersonalizeViewModelResult>) {
        observable
            .subscribe(on: MainScheduler.instance)
            .bind(onNext: self.onNext(_:))
            .disposed(by: self.disposeBag)
    }
    
    private func onNext(_ result: PFPersonalizeViewModelResult) {
        switch result {
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

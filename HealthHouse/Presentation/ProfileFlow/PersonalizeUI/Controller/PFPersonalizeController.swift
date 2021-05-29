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
final class PFPersonalizeController: UITableViewController {
    
    // MARK: DI Variable
    lazy var disposeBag = DisposeBag()
    lazy var rxMediaPicker = RxMediaPicker(delegate: self)
    lazy var _view: PFPersonalizeView = DefaultPFPersonalizeView()
    var viewModel: PFPersonalizeViewModel!
    
    // MARK: Common Variable
    lazy var countryDialingCodes: [CountryDialingCodeDomain] = []
    lazy var _countryDialingCode = BehaviorRelay<CountryDialingCodeDomain>(value: .indonesia)
    lazy var _dateOfBirth = BehaviorRelay<Date>(value: Date())
    lazy var _firstName = BehaviorRelay<String>(value: "")
    lazy var _gender = BehaviorRelay<GenderDomain>(value: .male)
    lazy var _lastName = BehaviorRelay<String>(value: "")
    lazy var _mobileNumbder = BehaviorRelay<String>(value: "")
    lazy var _photo = BehaviorRelay<UIImage?>(value: nil)
    lazy var _fieldValues = Observable.combineLatest(self._dateOfBirth,
                                                     self._firstName,
                                                     self._gender,
                                                     self._lastName,
                                                     self._mobileNumbder,
                                                     self._photo)
    lazy var _firstOrLastNameOrPhoto = Observable.combineLatest(self._firstName, self._lastName, self._photo)
    
    // MARK: Create Function
    class func create(with viewModel: PFPersonalizeViewModel) -> PFPersonalizeController {
        let controller = PFPersonalizeController()
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: UIViewController Function
    override func loadView() {
        self.bindTableViewDelegate(tableView: self._view.tableView)
        self.view = self._view.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModelResult(result: self.viewModel.result)
        self.bindShowedCountryDialingCodesToCountryDialingCodes(showedCountryDialingCodes: self.viewModel.showedCountryDialingCodes)
        self.bindShowedCountryDialingCodesToCountryDialingCodePicker(showedCountryDialingCodes: self.viewModel.showedCountryDialingCodes,
                                                                     picker: self._view.countryDialignCodePicker)
        self.bindFieldValuesToCreateBarButtonItemEnabled(fieldValues: self._fieldValues,
                                                         barButtonItem: self._view.createBarButtonItem)
        self.bindCreateBarButtonItemTapToFieldValues(barButtonItem: self._view.createBarButtonItem,
                                                     observable: self._fieldValues)
        self.bindDatePickerToDateOfBirth(datePicker: self._view.dateOfBirthPicker,
                                         dateOfBirth: self._dateOfBirth)
        self.bindGenderToPicker(picker: self._view.genderPicker)
        self.bindGenderPickerToGender(picker: self._view.genderPicker, gender: self._gender)
        self.bindCountryDialingCodePickerToCountryDialingCode(picker: self._view.countryDialignCodePicker,
                                                              countryDialingCode: self._countryDialingCode)
        self.bindSectionsToTableView(sections: Observable.just(self._view.sections),
                                     tableView: self._view.tableView)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._view.viewWillAppear(navigationController: self.navigationController,
                                            navigationItem: self.navigationItem,
                                            tabBarController: self.tabBarController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._view.viewWillDisappear()
    }
    
}

// MARK: BindAddPhotoButtonToPhoto
extension PFPersonalizeController {
    
    func bindAddPhotoButtonToPhoto(button: UIButton, photo: BehaviorRelay<UIImage?>) {
        button.rx.tap
            .flatMap({ [unowned self] in self.rxMediaPicker.selectImage(source: .photoLibrary, editable: true) })
            .map({ $0.0 })
            .bind(to: photo)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCountryDialingCodePickerToSubject
extension PFPersonalizeController {
    
    func bindCountryDialingCodePickerToCountryDialingCode(picker: UIPickerView,
                                                          countryDialingCode: BehaviorRelay<CountryDialingCodeDomain>) {
        picker.rx
            .itemSelected
            .asDriver()
            .drive(onNext: { [unowned self, unowned countryDialingCode] (row, component) in
                let selectedCountryDialingCode = self.countryDialingCodes[row]
                countryDialingCode.accept(selectedCountryDialingCode)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCountryDialingCodePickerToTextField
extension PFPersonalizeController {
    
    func bindCountryDialingCodeToTextFieldAndCountryDialingCodePicker(countryDialingCode: BehaviorRelay<CountryDialingCodeDomain>,
                                                                      textField: UITextField,
                                                                      picker: UIPickerView) {
        countryDialingCode
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
            .withLatestFrom(observable)
            .bind(onNext: { [unowned self] (observable) in
                self.viewModel.doCreate(dateOfBirth: observable.0,
                                        firstName: observable.1,
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
    
    func bindDateOfBirthToTextField(dateOfBirth: BehaviorRelay<Date>, textField: UITextField) {
        dateOfBirth
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
    
    func bindDatePickerToDateOfBirth(datePicker: UIDatePicker, dateOfBirth: BehaviorRelay<Date>) {
        datePicker.rx.date
            .asDriver()
            .drive(dateOfBirth)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindFieldValuesToBarButtonItemEnabled
extension PFPersonalizeController {
    
    func bindFieldValuesToCreateBarButtonItemEnabled(fieldValues: Observable<(Date,
                                                                              String,
                                                                              GenderDomain,
                                                                              String,
                                                                              String,
                                                                              UIImage?)>,
                                                     barButtonItem: UIBarButtonItem) {
        fieldValues
            .observe(on: ConcurrentMainScheduler.instance)
            .map({ (_, firstName, _, _, mobileNumber, _) -> Bool in
                let isFirstNameValid = firstName.isFirstOrLastNameValid
                let isMobileNumberValid = mobileNumber.isMobileNumberValid
                return isFirstNameValid && isMobileNumberValid
            })
            .asDriver(onErrorJustReturn: false)
            .drive(barButtonItem.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindFirstNameToHDPhotoProfileTableCell
extension PFPersonalizeController {
    
    func bindFirstOrLastNameOrPhotoToHDPhotoProfileTableCell(observable: Observable<(String, String, UIImage?)>,
                                                             cell: PhotoProfileTableCell) {
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

// MARK: BindGenderToPicker
extension PFPersonalizeController {
    
    func bindGenderToPicker(picker: UIPickerView) {
        Observable<[GenderDomain]>
            .just(GenderDomain.allCases)
            .bind(to: picker.rx.itemTitles) { (_, item) -> String? in
                return item.rawValue.capitalized
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindGenderPickerToGender
extension PFPersonalizeController {
    
    func bindGenderPickerToGender(picker: UIPickerView, gender: BehaviorRelay<GenderDomain>) {
        picker.rx
            .itemSelected
            .asDriver()
            .drive(onNext: { [unowned gender] (row, _) in
                gender.accept(GenderDomain.allCases[row])
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindGenderToTextField
extension PFPersonalizeController {
    
    func bindGenderToTextField(gender: BehaviorRelay<GenderDomain>, textField: UITextField) {
        gender
            .asDriver(onErrorJustReturn: .male)
            .map({ $0.rawValue.capitalized })
            .drive(textField.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindMobileNumberTextFieldEditingChanged
extension PFPersonalizeController {
    
    func bindMobileNumberTextFieldEditingChangedToMobileNumber(textField: UITextField,
                                                               mobileNumber: BehaviorRelay<String>) {
        textField.rx
            .controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned textField, unowned mobileNumber] in
                let text = textField.text!
                textField.text = String(text.prefix(15))
                if text.first == "0" {
                    textField.text = ""
                }
                mobileNumber.accept(textField.text!)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: BindPhotoToPhotoImageView
extension PFPersonalizeController {
    
    func bindPhotoToPhotoImageView(photo: BehaviorRelay<UIImage?>, imageView: UIImageView) {
        photo
            .asDriver(onErrorJustReturn: nil)
            .drive(imageView.rx.image)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindShowedCountryDialingCodeToCountryDialingCodes
extension PFPersonalizeController {
    
    func bindShowedCountryDialingCodesToCountryDialingCodes(showedCountryDialingCodes: Observable<[CountryDialingCodeDomain]>) {
        showedCountryDialingCodes
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] in
                self.countryDialingCodes = $0
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindShowedCountryDialingCodeToCountryDialingCodePicker
extension PFPersonalizeController {
    
    func bindShowedCountryDialingCodesToCountryDialingCodePicker(showedCountryDialingCodes: Observable<[CountryDialingCodeDomain]>,
                                                                 picker: UIPickerView) {
        showedCountryDialingCodes
            .asDriver(onErrorJustReturn: [])
            .drive(picker.rx.itemTitles) {
                return "\($1.code) (\($1.flag)) \($1.dialCode)"
            }
            .disposed(by: self.disposeBag)
    }
    
}


// MARK: BindTextFieldToString
extension PFPersonalizeController {
    
    func bindTextFieldToFirstOrLastName(textField: UITextField, firstOrLastName: BehaviorRelay<String>) {
        textField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(textField.rx.text.orEmpty)
            .filter({ $0.isFirstOrLastNameValid })
            .asDriver(onErrorJustReturn: "")
            .drive(firstOrLastName)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindViewModelResult
extension PFPersonalizeController {
    
    func bindViewModelResult(result: PublishRelay<PFPersonalizeViewModelResult>) {
        result
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
            let continueAction = UIAlertAction(title: "Continue", style: .default) { [unowned self] (action) in
                self.viewModel.pushToHDTimelineUI()
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

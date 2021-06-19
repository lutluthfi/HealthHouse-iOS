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
    lazy var _view: PFPersonalizeView = {
        let isPresented = self.presentingViewController != nil
        return DefaultPFPersonalizeView(isPresented: isPresented)
    }()
    var viewModel: PFPersonalizeViewModel!
    
    // MARK: Common Variable
    lazy var countryDialingCodes: [CountryDialingCodeDomain] = []
    lazy var _countryDialingCode = BehaviorRelay<CountryDialingCodeDomain>(value: .indonesia)
    lazy var _dateOfBirth = BehaviorRelay<Date>(value: Date())
    lazy var _firstName = BehaviorRelay<String>(value: "")
    lazy var _gender = BehaviorRelay<Gender>(value: .male)
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
        self.bind(cancelBarButtonItemTap: self._view.cancelBarButtonItem)
        self.bind(viewModelResult: self.viewModel.result)
        self.bind(showedCountryDialingCodes: self.viewModel.showedCountryDialingCodes)
        self.bind(showedCountryDialingCodes: self.viewModel.showedCountryDialingCodes,
                  toCountryDialingCodePicker: self._view.countryDialignCodePicker)
        self.bind(fieldValues: self._fieldValues,
                  toCreateBarButtonItemEnabled: self._view.createBarButtonItem)
        self.bind(createBarButtonItemTap: self._view.createBarButtonItem,
                  toFieldValues: self._fieldValues)
        self.bind(datePicker: self._view.dateOfBirthPicker,
                  toDateOfBirth: self._dateOfBirth)
        self.bind(genders: .just(Gender.allCases), toGenderPicker: self._view.genderPicker)
        self.bind(genderPicker: self._view.genderPicker, toGender: self._gender)
        self.bind(countryDialingCodePicker: self._view.countryDialignCodePicker,
                  toCountryDialingCode: self._countryDialingCode)
        self.bind(sections: Observable.just(self._view.sections),
                  toTableView: self._view.tableView)
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
    
    func bind(addPhotoButtonTapInCell button: UIButton, addPhotoButtonTap photo: BehaviorRelay<UIImage?>) {
        button.rx.tap
            .flatMap({ [unowned self] in
                self.rxMediaPicker.selectImage(source: .photoLibrary, editable: true)
            })
            .map({ $0.0 })
            .bind(to: photo)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCancelBarButtonItemTap
extension PFPersonalizeController {
    
    func bind(cancelBarButtonItemTap barButtonItem: UIBarButtonItem) {
        barButtonItem.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.viewModel.controllerDidDismiss()
                self.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindCountryDialingCodePickerToSubject
extension PFPersonalizeController {
    
    func bind(countryDialingCodePicker: UIPickerView,
              toCountryDialingCode countryDialingCode: BehaviorRelay<CountryDialingCodeDomain>) {
        countryDialingCodePicker.rx
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
    
    func bind(countryDialingCode: BehaviorRelay<CountryDialingCodeDomain>,
              toPromptTextFieldInCell textField: UITextField,
              toCountryDialingCodePicker picker: UIPickerView) {
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
    
    func bind(createBarButtonItemTap barButtonItem: UIBarButtonItem,
              toFieldValues fieldValues: Observable<(Date,
                                                     String,
                                                     Gender,
                                                     String,
                                                     String,
                                                     UIImage?)>) {
        barButtonItem.rx.tap
            .withLatestFrom(fieldValues)
            .bind(onNext: { [unowned self] (observable) in
                self.viewModel.createBarButtonDidTap(dateOfBirth: observable.0,
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
    
    func bind(dateOfBirth: BehaviorRelay<Date>, toTextFieldInCell textField: UITextField) {
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
    
    func bind(datePicker: UIDatePicker, toDateOfBirth dateOfBirth: BehaviorRelay<Date>) {
        datePicker.rx.date
            .asDriver()
            .drive(dateOfBirth)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindFieldValuesToBarButtonItemEnabled
extension PFPersonalizeController {
    
    func bind(fieldValues: Observable<(Date,
                                       String,
                                       Gender,
                                       String,
                                       String,
                                       UIImage?)>,
              toCreateBarButtonItemEnabled barButtonItem: UIBarButtonItem) {
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
    
    func bind(firstOrLastNameOrPhoto observable: Observable<(String, String, UIImage?)>,
              toPhotoProfileTableCell cell: PhotoProfileTableCell) {
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
    
    func bind(genders: Observable<[Gender]>, toGenderPicker picker: UIPickerView) {
        genders
            .bind(to: picker.rx.itemTitles) { (_, item) -> String? in
                return item.rawValue.capitalized
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindGenderPickerToGender
extension PFPersonalizeController {
    
    func bind(genderPicker: UIPickerView, toGender gender: BehaviorRelay<Gender>) {
        genderPicker.rx
            .itemSelected
            .asDriver()
            .drive(onNext: { [unowned gender] (row, _) in
                gender.accept(Gender.allCases[row])
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindGenderToTextField
extension PFPersonalizeController {
    
    func bind(gender: BehaviorRelay<Gender>, toTextFieldInCell textField: UITextField) {
        gender
            .asDriver(onErrorJustReturn: .male)
            .map({ $0.rawValue.capitalized })
            .drive(textField.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindMobileNumberTextFieldEditingChanged
extension PFPersonalizeController {
    
    func bind(mobileNumerTextFieldEditingChangedInCell textField: UITextField,
              toMobileNumber mobileNumber: BehaviorRelay<String>) {
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
    
    func bind(photo: BehaviorRelay<UIImage?>, toPhotoImageViewInCell imageView: UIImageView) {
        photo
            .asDriver(onErrorJustReturn: nil)
            .drive(imageView.rx.image)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindShowedCountryDialingCodeToCountryDialingCodes
extension PFPersonalizeController {
    
    func bind(showedCountryDialingCodes: BehaviorRelay<[CountryDialingCodeDomain]>) {
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
    
    func bind(showedCountryDialingCodes: BehaviorRelay<[CountryDialingCodeDomain]>,
              toCountryDialingCodePicker picker: UIPickerView) {
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
    
    func bind(textFieldInCell textField: UITextField, toFirstOrLastName firstOrLastName: BehaviorRelay<String>) {
        textField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(textField.rx.text.orEmpty)
            .filter({ $0.isFirstOrLastNameValid })
            .asDriver(onErrorJustReturn: "")
            .drive(firstOrLastName)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: RxMediaPickerDelegate
extension PFPersonalizeController: RxMediaPickerDelegate {
}

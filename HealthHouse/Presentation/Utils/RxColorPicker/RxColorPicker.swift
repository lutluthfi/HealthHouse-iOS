//
//  RxColorPicker.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import RxSwift
import UIKit

enum RxColorPickerAction {
    case color(observer: AnyObserver<UIColor>)
}

@available(iOS 14.0, *)
@objc open class RxColorPicker: NSObject, UIColorPickerViewControllerDelegate {
    weak var delegate: RxColorPickerDelegate?
    
    fileprivate var currentAction: RxColorPickerAction?
    
    public init(delegate: RxColorPickerDelegate) {
        self.delegate = delegate
    }
    
}

@available(iOS 14.0, *)
extension RxColorPicker {
    
    open func selectColor(initialColor: UIColor? = nil) -> Observable<UIColor> {
        return Observable.create { [unowned self, unowned initialColor] (observer) -> Disposable in
            self.currentAction = RxColorPickerAction.color(observer: observer)
            
            let picker = UIColorPickerViewController()
            if let initialColor = initialColor {
                picker.selectedColor = initialColor
            }
            picker.delegate = self
            
            self.present(picker)
            
            return Disposables.create()
        }
        .observe(on: ConcurrentMainScheduler.instance)
    }
    
}

@available(iOS 14.0, *)
extension RxColorPicker {
    
    open func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
    }
    
    open func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        guard let action = self.currentAction else { return }
        switch action {
        case .color(let observer):
            observer.onNext(viewController.selectedColor)
        }
    }
    
}

@available(iOS 14.0, *)
fileprivate extension RxColorPicker {
    
    func present(_ picker: UIColorPickerViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.present(picker: picker)
        }
    }
    
    func dismiss(_ picker: UIColorPickerViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.dismiss(picker: picker)
        }
    }
    
}


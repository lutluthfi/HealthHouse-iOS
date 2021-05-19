//
//  RxColorPickerDelegate.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import RxSwift
import UIKit

@available(iOS 14.0, *)
public protocol RxColorPickerDelegate: AnyObject {
    func present(picker: UIColorPickerViewController)
    func dismiss(picker: UIColorPickerViewController)
}

@available(iOS 14.0, *)
extension RxColorPickerDelegate where Self: UIViewController {
    func present(picker: UIColorPickerViewController) {
        self.present(picker, animated: true, completion: .none)
    }
    
    func dismiss(picker: UIColorPickerViewController) {
        self.dismiss(animated: true, completion: .none)
    }
}

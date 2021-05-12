//
//  RxDocumentPickerDelegate.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 12/05/21.
//

import RxSwift
import UIKit

public protocol RxDocumentPickerDelegate: AnyObject {
    func present(picker: UIDocumentPickerViewController)
    func dismiss(picker: UIDocumentPickerViewController)
}

extension RxDocumentPickerDelegate where Self: UIViewController {
    func present(picker: UIDocumentPickerViewController) {
        self.present(picker, animated: true, completion: .none)
    }
    
    func dismiss(picker: UIDocumentPickerViewController) {
        self.dismiss(animated: true, completion: .none)
    }
}

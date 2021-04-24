//
//  RxMediaPickerDelegate.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 13/04/21.
//

import RxSwift
import UIKit

extension RxMediaPickerDelegate where Self: UIViewController {
    func present(picker: UIImagePickerController) {
        self.present(picker, animated: true, completion: .none)
    }
    
    func dismiss(picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: .none)
    }
}

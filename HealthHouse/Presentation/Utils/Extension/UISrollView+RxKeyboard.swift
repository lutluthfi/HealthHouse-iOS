//
//  UISrollView+RxKeyboard.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 09/04/21.
//

import RxKeyboard
import RxSwift
import UIKit

extension UIScrollView {
    
    func bindKeyboardHeight(disposeBag: DisposeBag) {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { self.contentInset.bottom = $0 })
            .disposed(by: disposeBag)
    }
    
}

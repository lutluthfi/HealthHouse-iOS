//
//  UISrollView+RxKeyboard.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 09/04/21.
//

import RxKeyboard
import RxSwift
import UIKit

public extension UIScrollView {
    
    func bindKeyboardHeight(disposeBag: DisposeBag) {
        RxKeyboard.instance
            .visibleHeight
            .map({ UIEdgeInsets(top: 0, left: 0, bottom: $0, right: 0) })
            .drive(self.rx.contentInset)
            .disposed(by: disposeBag)
    }
    
}

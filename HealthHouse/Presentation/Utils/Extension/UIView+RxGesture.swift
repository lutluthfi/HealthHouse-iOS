//
//  UIView+RxGesture.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/04/21.
//

import Foundation
import RxCocoa
import RxSwift

public extension UIView {
    
    func bindTapGestureForEndEditing(disposeBag: DisposeBag) {
        self.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [unowned self] (_) in
                self.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
}

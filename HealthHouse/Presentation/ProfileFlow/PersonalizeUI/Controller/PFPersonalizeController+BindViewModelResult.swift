//
//  PFPersonalizeController+BindViewModelResult.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 19/06/21.
//

import RxCocoa
import RxSwift
import UIKit

// MARK: BindViewModelResult
extension PFPersonalizeController {
    
    func bind(viewModelResult result: PublishRelay<PFPersonalizeViewModelResult>) {
        result
            .subscribe(on: MainScheduler.instance)
            .bind(onNext: self.onNext(_:))
            .disposed(by: self.disposeBag)
    }
    
    private func onNext(_ result: PFPersonalizeViewModelResult) {
        switch result {
        case .profileDidCreate(let result):
            self.onNextProfileDidCreate(result)
        }
    }
    
    private func onNextProfileDidCreate(_ result: AnyResult<String, String>) {
        switch result {
        case .success(let message):
            let continueAction = UIAlertAction(title: "Continue", style: .default) { [unowned self] (action) in
                if self.isPresented {
                    self.dismiss(animated: true)
                }
            }
            self.showAlert(title: "Congratulations 🎉", message: message, actions: [continueAction])
        case .failure(let message):
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            self.showAlert(title: "Failure 😕", message: message, actions: [dismissAction])
        }
    }
    
}

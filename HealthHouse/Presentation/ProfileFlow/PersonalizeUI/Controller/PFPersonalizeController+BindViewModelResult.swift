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

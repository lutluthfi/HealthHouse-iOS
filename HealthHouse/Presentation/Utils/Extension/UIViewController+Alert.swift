//
//  UIViewController+Alert.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

import RxSwift
import UIKit

public extension UIViewController {
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertController.addAction($0) }
        self.present(alertController, animated: true)
    }
    
    func showActionSheet(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { alertController.addAction($0) }
        self.present(alertController, animated: true)
    }
    
}

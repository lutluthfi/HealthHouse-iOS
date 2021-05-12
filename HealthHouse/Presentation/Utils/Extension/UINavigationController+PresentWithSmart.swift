//
//  UINavigationController+PresentWithSmart.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 12/05/21.
//

import UIKit

public extension UINavigationController {
    
    /// Presents a view controller modally.
    ///
    /// Using the same functionality with `present` function by `UINavigationController` with animate by default and no completion. The difference in this function is when the `UINavigationController` is already presenting another `UIViewController`, it will present the new view controller by using the presented controller.
    ///
    /// - Author:
    ///   Arif Luthfiansyah
    ///
    /// - Parameters:
    ///   - controller: The view controller to display over the current view controller’s content.
    ///
    func presentWithSmart(controller: UIViewController) {
        guaranteeMainThread {
            if let presentedController = self.presentedViewController {
                presentedController.present(controller, animated: true)
            } else {
                self.present(controller, animated: true)
            }
        }
    }
    
}

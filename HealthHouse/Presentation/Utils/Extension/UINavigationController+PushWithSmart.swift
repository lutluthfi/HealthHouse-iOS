//
//  UINavigationController+PushWithSmart.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 12/05/21.
//

import UIKit

public extension UINavigationController {
    
    /// Pushes a view controller onto the receiver’s stack and updates the display.
    ///
    /// Using the same functionality with `pushViewController` function by `UINavigationController` with animate by default. The difference in this function is when the `UINavigationController` is already presenting another `UINavigationController`, it will push the view controller by using the the presented `UINavigationController`.
    ///
    /// - Author:
    ///   Arif Luthfiansyah
    ///
    /// - Parameters:
    ///   - controller: The view controller to push onto the stack. This object cannot be a tab bar controller. If the view controller is already on the navigation stack, this method throws an exception.
    ///
    func pushWithSmart(to controller: UIViewController) {
        guaranteeMainThread {
            if let navigationController = self.presentedViewController as? UINavigationController {
                navigationController.pushViewController(controller, animated: true)
            } else {
                self.pushViewController(controller, animated: true)
            }
        }
    }
    
}

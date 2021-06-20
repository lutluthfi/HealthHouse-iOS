//
//  UIViewController+Presented.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 19/06/21.
//

import UIKit

extension UIViewController {
 
    /// Indicate whether the presenting view controller is `nil` or not.
    /// Not `nil` means this view controller is being presenter by another view controller.
    var isPresented: Bool {
        return self.presentingViewController != nil
    }
    
}

//
//  UIBarButton+InputAccessoryView.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 02/04/21.
//

import UIKit

public extension UIBarButtonItem {
    
    static var done: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    }
    
    static var flexible: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
}

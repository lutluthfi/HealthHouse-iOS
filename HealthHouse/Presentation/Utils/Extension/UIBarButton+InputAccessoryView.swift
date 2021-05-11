//
//  UIBarButton+InputAccessoryView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/04/21.
//

import UIKit

public extension UIBarButtonItem {
    
    static var add: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
    
    static var edit: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
    }
    
    static var done: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    }
    
    static var flexible: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
}

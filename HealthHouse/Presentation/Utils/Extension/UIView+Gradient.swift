//
//  UIView+Gradient.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 12/04/21.
//

import UIKit

enum GradientDirection {
    case leadingToTrailing
    case bottomToTop
}

extension UIView {
    
    func gradient(direction: GradientDirection = .leadingToTrailing, colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        
        switch direction {
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case .leadingToTrailing:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        self.layer.masksToBounds = true
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

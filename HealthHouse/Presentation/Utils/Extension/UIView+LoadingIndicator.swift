//
//  UIView+LoadingIndicator.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 21/04/21.
//

import UIKit

public extension Int {
    
    static let loadingIndicatorTag = Int(9991)
    
}

public extension UIView {
    
    func hideLoadingIndicator() {
        guard let indicatorView = self.subviews.first(where: { $0.tag == .loadingIndicatorTag }) else { return }
        indicatorView.removeFromSuperview()
    }
    
    func showLoadingIndicator() {
        guard !self.subviews.contains(where: { $0.tag == .loadingIndicatorTag }) else { return }
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.tag = .loadingIndicatorTag
        let size = CGFloat(44)
        let xpoint = (UIScreen.main.fixedCoordinateSpace.bounds.width / 2) - (size / 2)
        let ypoint = (UIScreen.main.fixedCoordinateSpace.bounds.height / 2) - (size / 2)
        indicatorView.frame = CGRect(x: xpoint,
                                     y: ypoint,
                                     width: size,
                                     height: size)
        self.addSubview(indicatorView)
        indicatorView.startAnimating()
    }
    
}

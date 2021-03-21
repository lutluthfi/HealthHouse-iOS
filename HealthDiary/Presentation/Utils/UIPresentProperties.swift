//
//  UIPresentProperties.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 20/03/21.
//

import UIKit

struct UIPresentProperties {
    
    static let standard = UIPresentProperties()
    
    let isModalInPresentation: Bool
    let modalPresentationStyle: UIModalPresentationStyle
    let modalTransitionStyle: UIModalTransitionStyle
    
    init(isModalInPresentation: Bool = false,
         modalPresentationStyle: UIModalPresentationStyle = .automatic,
         modalTransitionStyle: UIModalTransitionStyle = .coverVertical) {
        self.isModalInPresentation = isModalInPresentation
        self.modalPresentationStyle = modalPresentationStyle
        self.modalTransitionStyle = modalTransitionStyle
    }
    
}

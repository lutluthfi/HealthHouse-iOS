//
//  PFPersonalizeController+UITableViewDelegate.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 05/04/21.
//

import UIKit

// MARK: BindTableViewDelegate
extension PFPersonalizeController {
    
    func bindTableViewDelegate(tableView: UITableView) {
        tableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: UITableViewDelegate
extension PFPersonalizeController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        let field = self.personalizeView.sections[section][row]
        switch field {
        case .photo:
            return HHPhotoProfileTableCell.height
        default:
            return HHTextFieldTableCell.height
        }
    }
    
}
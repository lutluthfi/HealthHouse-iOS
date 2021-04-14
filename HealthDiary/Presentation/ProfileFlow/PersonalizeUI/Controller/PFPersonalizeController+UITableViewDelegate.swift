//
//  PFPersonalizeController+UITableViewDelegate.swift
//  HealthDiary
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
        let field = self.personalizeView.personalizeFields[section][row]
        switch field {
        case .photo:
            return HDPhotoProfileTableCell.height
        default:
            return HDTextFieldTableCell.height
        }
    }
    
}

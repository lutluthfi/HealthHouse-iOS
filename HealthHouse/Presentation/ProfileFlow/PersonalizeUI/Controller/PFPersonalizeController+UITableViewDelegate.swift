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
extension PFPersonalizeController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        let field = self._view.sections[section][row]
        switch field {
        case .photo:
            return PhotoProfileTableCell.height
        default:
            return TextFieldTableCell.height
        }
    }
    
}

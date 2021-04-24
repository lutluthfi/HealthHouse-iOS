//
//  HDTLTimelineCollectionCell.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 22/04/21.
//

import UIKit

class HDTLTimelineCollectionCell: UICollectionViewCell {
    
    static let identifier = String(describing: HDTLTimelineCollectionCell.self)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.subviewWillAdd()
        self.subviewConstraintWillMake()
        self.viewDidInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviewDidLayout()
    }
    
    private func subviewDidLayout() {
    }
    
    private func subviewWillAdd() {
        self.contentView.addSubview(self.tableView)
    }
    
    private func subviewConstraintWillMake() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func viewDidInit() {
    }
    
}

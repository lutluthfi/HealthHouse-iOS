//
//  HHDatePickerTableCell.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 29/04/21.
//

import UIKit

public final class HHDatePickerTableCell: UITableViewCell {
    
    public static let identifier = String(describing: HHDatePickerTableCell.self)
    
    public lazy var contentContainerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reuseIdentifier: String? = HHDatePickerTableCell.identifier) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.subviewWillAdd()
        self.subviewConstraintWillMake()
        self.viewDidInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.subviewDidLayout()
    }
    
    private func subviewDidLayout() {
    }
    
    private func subviewWillAdd() {
        self.contentView.addSubview(self.contentContainerView)
        self.contentContainerView.addSubview(self.datePicker)
    }
    
    private func subviewConstraintWillMake() {
        self.contentContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.datePicker.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func viewDidInit() {
    }
    
}

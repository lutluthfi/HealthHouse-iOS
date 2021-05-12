//
//  HHTextFieldTableCell.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//

import UIKit

public enum HHTextFieldTableCellStyle {
    case plain
    case prompt
}

public final class HHTextFieldTableCell: UITableViewCell {
    
    public static let identifier = String(describing: HHTextFieldTableCell.self)
    public static let height = CGFloat(44)

    public lazy var promptTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 17)
        textField.autocorrectionType = .no
        textField.isEnabled = false
        return textField
    }()
    public lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        return stackView
    }()
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.font = .systemFont(ofSize: 17)
        return textField
    }()
    
    private let _style: HHTextFieldTableCellStyle
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(reuseIdentifier: String? = HHTextFieldTableCell.identifier, style: HHTextFieldTableCellStyle) {
        self._style = style
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.subviewWillAdd(style: style)
        self.subviewConstraintWillMake(style: style)
        self.viewDidInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.subviewDidLayout()
    }
    
    private func subviewWillAdd(style: HHTextFieldTableCellStyle) {
        switch style {
        case .plain:
            self.contentView.addSubview(self.textField)
        case .prompt:
            self.stackView.addArrangedSubview(self.promptTextField)
            self.stackView.addArrangedSubview(self.textField)
            self.contentView.addSubview(self.stackView)
        }
    }
    
    private func subviewConstraintWillMake(style: HHTextFieldTableCellStyle) {
        switch style {
        case .plain:
            self.textField.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().inset(20)
                make.top.bottom.trailing.equalToSuperview()
            }
        case .prompt:
            self.promptTextField.snp.makeConstraints { (make) in
                let width = self.frame.width * 0.35
                make.width.equalTo(width)
            }
            self.stackView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().inset(20)
                make.top.bottom.trailing.equalToSuperview()
            }
        }
    }
    
    private func subviewDidLayout() {
        // do nothing
    }
    
    private func viewDidInit() {
        self.selectionStyle = .none
    }

}

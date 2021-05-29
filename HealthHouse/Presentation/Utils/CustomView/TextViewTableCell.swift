//
//  TextViewTableCell.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 30/04/21.
//

import UIKit

public final class TextViewTableCell: UITableViewCell {
    
    public static let identifier = String(describing: TextViewTableCell.self)
    
    public lazy var contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .appleTextPlaceholder
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    public lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 6)
        textView.autocorrectionType = .no
        return textView
    }()
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reuseIdentifier: String? = TextViewTableCell.identifier) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.subviewWillAdd()
        self.subviewConstraintWillMake()
        self.viewDidInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.subviewDidLayout()
    }
    
    private func subviewConstraintWillMake() {
        self.contentContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.placeholderLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-6)
        }
        self.textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func subviewDidLayout() {
    }
    
    private func subviewWillAdd() {
        self.contentView.addSubview(self.contentContainerView)
        self.contentContainerView.addSubview(self.textView)
        self.contentContainerView.addSubview(self.placeholderLabel)
    }
    
    private func viewDidInit() {
        
    }
    
}

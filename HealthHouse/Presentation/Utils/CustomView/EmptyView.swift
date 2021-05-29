//
//  EmptyView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 29/05/21.
//

import UIKit

public final class EmptyView: UIView {
    
    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
        self.addSubview(self.textLabel)
    }
    
    private func subviewConstraintWillMake() {
        self.textLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func viewDidInit() {
        
    }
    
}

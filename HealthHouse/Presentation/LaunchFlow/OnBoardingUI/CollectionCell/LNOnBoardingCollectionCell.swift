//
//  LNOnBoardingCollectionCell.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/06/21.
//

import UIKit

final class LNOnBoardingCollectionCell: UICollectionViewCell {
    
    static let identifier = String(describing: LNOnBoardingCollectionCell.self)
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    var imageName: String? {
        didSet {
            self.imageView.image = UIImage(named: self.imageName.orEmpty)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.subviewWillAdd()
        self.subviewWillMakeConstraint()
        self.viewDidInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviewDidLayout()
    }
    
    func subviewWillAdd() {
        self.contentView.addSubview(self.imageView)
    }
    
    func subviewWillMakeConstraint() {
        self.imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func subviewDidLayout() {
        
    }
    
    func viewDidInit() {
        
    }
    
}

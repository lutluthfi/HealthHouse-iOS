//
//  PhotoProfileTableCell.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 05/04/21.
//

import UIKit

public final class PhotoProfileTableCell: UITableViewCell {

    public static let identifier = String(describing: PhotoProfileTableCell.self)
    public static let height = CGFloat(180)

    public lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    public lazy var photoBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    public lazy var contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var abbreviationName: String = "" {
        didSet {
            self.abbreviationNameDidSet(self.abbreviationName)
        }
    }
    public var photoImage: UIImage? = nil {
        didSet {
            self.photoImageDidSet(self.photoImage)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init(style: .default, reuseIdentifier: PhotoProfileTableCell.identifier)
        self.subviewWillAdd()
        self.subviewConstraintWillMake()
        self.viewDidInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.subviewDidLayout()
    }
    
    private func subviewWillAdd() {
        self.contentView.addSubview(self.contentContainerView)
        self.contentContainerView.addSubview(self.photoBackgroundView)
        self.contentContainerView.addSubview(self.addPhotoButton)
        self.contentContainerView.addSubview(self.photoImageView)
    }
    
    private func subviewConstraintWillMake() {
        self.contentContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.photoBackgroundView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(self.photoBackgroundView.snp.height)
            make.top.equalToSuperview().inset(8)
        }
        self.photoImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.photoBackgroundView)
        }
        self.addPhotoButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(self.photoImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func subviewDidLayout() {
        guard self.photoImageView.frame != .zero else { return }
        let cornerRad = self.photoImageView.frame.width / 2
        self.photoImageView.makeRound(cornerRad: cornerRad)
        self.photoBackgroundView.makeRound(cornerRad: cornerRad)
        self.photoBackgroundView.gradient(direction: .bottomToTop,
                                          colors: [UIColor(red: 132 / 255, green: 138 / 255, blue: 148 / 255, alpha: 1),
                                                   UIColor(red: 165 / 255, green: 171 / 255, blue: 184 / 255, alpha: 1)])
    }
    
    private func viewDidInit() {
    }
    
}

extension PhotoProfileTableCell {
    
    func abbreviationNameDidSet(_ newValue: String) {
        let size = self.photoImageView.frame.size
        let stringImageProperties = StringImageProperties(color: .white, scale: 0.5, size: size.height)
        self.photoImageView.image = newValue.image(properties: stringImageProperties)
    }
    
    func photoImageDidSet(_ newValue: UIImage?) {
        self.photoImageView.image = newValue
    }
    
}

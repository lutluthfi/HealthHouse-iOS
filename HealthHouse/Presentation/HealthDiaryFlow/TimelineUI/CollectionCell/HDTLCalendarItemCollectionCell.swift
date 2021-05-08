//
//  HDTLCalendarItemCollectionCell.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/04/21.
//

import UIKit

class HDTLCalendarItemCollectionCell: UICollectionViewCell {
    
    static let identifier = String(describing: HDTLCalendarItemCollectionCell.self)
    
    lazy var contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .darkText
        label.numberOfLines = 1
        return label
    }()
    lazy var selectedMarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var todayMarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var date: Date? {
        didSet {
            self.todayDidSet(self.date)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.selectedMarkView.backgroundColor = self.isSelected ? .systemBlue : .clear
            self.dateLabel.textColor = self.isSelected ? .white : .black
            self.dateLabel.font = .preferredFont(forTextStyle: self.isSelected ? .headline : .body)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemeneted")
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
        self.contentView.addSubview(self.contentContainerView)
        self.contentContainerView.addSubview(self.todayMarkView)
        self.contentContainerView.addSubview(self.selectedMarkView)
        self.contentContainerView.addSubview(self.dateLabel)
    }
    
    private func subviewConstraintWillMake() {
        self.contentContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.todayMarkView.snp.makeConstraints { (make) in
            make.height.equalTo(self.contentView.frame.height / 1.5)
            make.width.equalTo(self.contentView.frame.height / 1.5)
            make.center.equalToSuperview()
        }
        self.selectedMarkView.snp.makeConstraints { (make) in
            make.height.equalTo(self.contentView.frame.height / 1.5)
            make.width.equalTo(self.contentView.frame.height / 1.5)
            make.center.equalToSuperview()
        }
        self.dateLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func viewDidInit() {
        let cornerRad = (self.contentView.frame.height / 1.5) / 2
        self.todayMarkView.makeRound(borderColor: .systemBlue,
                                     borderWidth: 2,
                                     cornerRad: cornerRad)
        self.selectedMarkView.makeRound(cornerRad: cornerRad)
    }
    
}

extension HDTLCalendarItemCollectionCell {
    
    func todayDidSet(_ date: Date?) {
        self.dateLabel.text = date?.formatted(components: [.dayOfMonth])
        let dateFormatted = date?.formatted(components: [.dayOfMonthPadding,
                                                         .monthOfYearDouble,
                                                         .yearFullDigits])
        let todayFormatted = Date().formatted(components: [.dayOfMonthPadding,
                                                           .monthOfYearDouble,
                                                           .yearFullDigits])
        self.todayMarkView.isHidden = dateFormatted != todayFormatted
    }
    
}

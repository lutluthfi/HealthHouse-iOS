//
//  HDLoadingButton.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 21/03/21.
//

import UIKit

public class HDLoadingButton: UIButton {
    
    public lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    private var _title: String?
    
    public var isLoading: Bool = false
    public var onTouchUpInside: ((UIButton) -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.subviewDidInit()
        self.subviewConstraintDidInit()
        self.viewDidInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.subviewDidInit()
        self.subviewConstraintDidInit()
        self.viewDidInit()
    }
    
    private func subviewDidInit() {
        self.addSubview(self.activityIndicator)
    }
    
    private func subviewConstraintDidInit() {
        self.activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func viewDidInit() {
        self.addTarget(self, action: #selector(self.onTouchUpInside(_:)) , for: .touchUpInside)
    }
    
}

// MARK: - @objc Function
extension HDLoadingButton {
    
    @objc
    private func onTouchUpInside(_ sender: UIButton) {
        self.onTouchUpInside?(sender)
    }
    
}

// MARK: - Public Function
extension HDLoadingButton {
    
    func showLoading() {
        DispatchQueue.main.async {
            self.isEnabled = false
            self._title = self.titleLabel?.text
            self.setTitle("", for: .normal)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.isEnabled = true
            self.setTitle(self._title, for: .normal)
            self.activityIndicator.stopAnimating()
        }
    }
    
}

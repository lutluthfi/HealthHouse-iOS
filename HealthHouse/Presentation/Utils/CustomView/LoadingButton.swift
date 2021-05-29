//
//  LoadingButton.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 21/03/21.
//

import UIKit

public class LoadingButton: UIButton {
    
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
        self.subviewWillAdd()
        self.subviewConstraintWillMake()
        self.viewDidInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.subviewWillAdd()
        self.subviewConstraintWillMake()
        self.viewDidInit()
    }
    
    private func subviewWillAdd() {
        self.addSubview(self.activityIndicator)
    }
    
    private func subviewConstraintWillMake() {
        self.activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
    
    private func viewDidInit() {
        self.addTarget(self, action: #selector(self.onTouchUpInside(_:)) , for: .touchUpInside)
    }
    
}

// MARK: - @objc Function
extension LoadingButton {
    
    @objc
    private func onTouchUpInside(_ sender: UIButton) {
        self.onTouchUpInside?(sender)
    }
    
}

// MARK: - Public Function
extension LoadingButton {
    
    func showLoading() {
        guaranteeMainThread {
            self.isEnabled = false
            self._title = self.titleLabel?.text
            self.setTitle("", for: .normal)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        guaranteeMainThread {
            self.isEnabled = true
            self.setTitle(self._title, for: .normal)
            self.activityIndicator.stopAnimating()
        }
    }
    
}

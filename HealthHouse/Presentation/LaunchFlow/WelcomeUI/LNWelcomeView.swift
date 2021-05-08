//
//  LNWelcomeView.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/03/21.
//  Copyright (c) 2021 All rights reserved.

import UIKit

// MARK: LNWelcomeViewFunction
protocol LNWelcomeViewFunction {
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?)
    func viewWillDisappear()
    func showContinueButton(_ completion: @escaping (Bool) -> Void)
}

// MARK: LNWelcomeViewSubview
protocol LNWelcomeViewSubview {
    var continueButton: UIButton { get }
    var logoImageView: UIImageView { get }
    var headerLabel: UILabel { get }
    var subheaderLabel: UILabel { get }
}

// MARK: LNWelcomeViewVariable
protocol LNWelcomeViewVariable {
}

// MARK: LNWelcomeView
protocol LNWelcomeView: LNWelcomeViewFunction, LNWelcomeViewSubview, LNWelcomeViewVariable { }

// MARK: DefaultLNWelcomeView
final class DefaultLNWelcomeView: UIView, LNWelcomeView {

    // MARK: Subview Variable
    lazy var continueButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        let title = NSMutableAttributedString(string: "Continue",
                                              attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
        button.setAttributedTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.makeRound()
        return button
    }()
    lazy var logoImageView: UIImageView = {
        let image = UIImage(systemName: "heart.text.square.fill")
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 52, weight: .heavy)
        let welcomeText = NSAttributedString(string: "Welcome to",
                                             attributes: [.foregroundColor: UIColor.black])
        let healthDiaryText = NSAttributedString(string: "\nHealth Diary",
                                                 attributes: [.foregroundColor: UIColor.systemBlue])
        let attributedText = NSMutableAttributedString()
        attributedText.append(welcomeText)
        attributedText.append(healthDiaryText)
        label.attributedText = attributedText
        label.numberOfLines = .zero
        return label
    }()
    lazy var subheaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "Your personal health diary. Your health is the best of gratitude."
        label.numberOfLines = .zero
        return label
    }()
    lazy var headerStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 0
        view.addArrangedSubview(self.headerLabel)
        view.addArrangedSubview(self.subheaderLabel)
        return view
    }()
    
    // MARK: Init Function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: UIScreen.main.fixedCoordinateSpace.bounds)
        self.subviewDidMake()
        self.subviewConstraintWillMake()
        self.viewDidInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviewDidLayout()
    }

}

// MARK: Internal Function
extension DefaultLNWelcomeView {
    
    func subviewDidLayout() {
        // do nothing
    }
    
    func subviewDidMake() {
        self.addSubview(self.logoImageView)
        self.addSubview(self.headerStackView)
        self.addSubview(self.continueButton)
    }
    
    func subviewConstraintWillMake() {
        self.logoImageView.snp.makeConstraints { (make) in
            make.size.equalTo(44)
            make.leading.equalTo(self.headerStackView.snp.leading)
            make.bottom.equalTo(self.headerStackView.snp.top).offset(-8)
        }
        self.headerStackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        self.continueButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(self.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    func viewDidInit() {
        self.backgroundColor = .white
        self.continueButton.isHidden = true
    }
    
}

// MARK: LNWelcomeViewFunction
extension DefaultLNWelcomeView {
    
    func viewWillAppear(navigationBar: UINavigationBar?,
                        navigationItem: UINavigationItem,
                        tabBarController: UITabBarController?) {
        guaranteeMainThread {
            navigationBar?.isHidden = true
        }
    }
    
    func viewWillDisappear() {
        // do nothing
    }
    
    func showContinueButton(_ completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5, animations: {
                self.headerStackView.snp.remakeConstraints { (make) in
                    make.leading.trailing.equalToSuperview().inset(32)
                    make.bottom.equalTo(self.snp.centerY)
                }
                self.continueButton.snp.remakeConstraints { (make) in
                    make.height.equalTo(50)
                    make.leading.trailing.equalToSuperview().inset(32)
                    make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
                }
                self.continueButton.isHidden = false
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }, completion: completion)
        }
    }
    
}

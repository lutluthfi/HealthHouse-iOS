//
//  LNOnBoardingController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/06/21.
//  Copyright (c) 2021 All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// MARK: LNOnBoardingController
final class LNOnBoardingController: UIViewController {

    // MARK: DI Variable
    lazy var _view: LNOnBoardingView = DefaultLNOnBoardingView()
    var viewModel: LNOnBoardingViewModel!

    // MARK: Common Variable
    let disposeBag = DisposeBag()

    // MARK: Create Function
    class func create(with viewModel: LNOnBoardingViewModel) -> LNOnBoardingController {
        let controller = LNOnBoardingController()
        controller.viewModel = viewModel
        return controller
    }

    // MARK: UIViewController Function
    override func loadView() {
        self.view = self._view.asView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(to: self.viewModel)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._view.viewWillAppear(navigationBar: self.navigationController?.navigationBar,
                                  navigationItem: self.navigationItem,
                                  tabBarController: self.tabBarController)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bindWalkthroughImagesToCollectionView(walkthroughImages: .just(self._view.walkthroughImageNames),
                                                   collectionView: self._view.collectionView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._view.viewWillDisappear()
    }

    // MARK: Bind ViewModel Function
    private func bind(to viewModel: LNOnBoardingViewModel) {
    }
    
}

// MARK: BindWalkthroughImagesToCollectionView
extension LNOnBoardingController {
    
    func bindWalkthroughImagesToCollectionView(walkthroughImages: Driver<[String]>,
                                               collectionView: UICollectionView) {
        let dataSource = self.makeCollectionViewDataSource()
        walkthroughImages
            .map { [SectionDomain(footer: nil, header: "", items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeCollectionViewDataSource() -> RxCollectionViewSectionedAnimatedDataSource<SectionDomain<String>> {
        .init { (_, collectionView, indexPath, imageName) -> UICollectionViewCell in
            let identifier = LNOnBoardingCollectionCell.identifier
            let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            guard let cell = reusableCell as? LNOnBoardingCollectionCell else { return reusableCell }
            cell.imageName = imageName
            return cell
        }
    }
    
}

//
//  LCSearchController.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/04/21.
//  Copyright (c) 2021 All rights reserved.

import MapKit
import RxCocoa
import RxCoreLocation
import RxDataSources
import RxSwift
import UIKit

// MARK: LCSearchController
final class LCSearchController: SearchResultController {

    // MARK: DI Variable
    let disposeBag = DisposeBag()
    let locationManager = CLLocationManager()
    lazy var searchView: LCSearchView = DefaultLCSearchView()
    var viewModel: LCSearchViewModel!
    lazy var _view: UIView = (self.searchView as! UIView)

    // MARK: Common Variable
    let showedMapItems = BehaviorSubject<[MKMapItem]>(value: [])
    let _currLocation = PublishSubject<CLLocation>()
    let _searchText = PublishSubject<String>()
    lazy var _currLocationSearchText = Observable.combineLatest(self._currLocation,
                                                                self._searchText)

    // MARK: Create Function
    class func create(with viewModel: LCSearchViewModel) -> LCSearchController {
        let controller = LCSearchController()
        controller.viewModel = viewModel
        return controller
    }

    // MARK: UIViewController Function
    override func loadView() {
        self.view = self._view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.startUpdatingLocation()
        self.bindCurrLocationSearchTextToShowedMapItems(observable: self._currLocationSearchText,
                                                        subject: self.showedMapItems)
        self.bindShowedMapItemsToTableView(observable: self.showedMapItems, tableView: self.searchView.tableView)
        self.bindTableViewModelSelectedToViewModel(tableView: self.searchView.tableView, viewModel: self.viewModel)
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchView.viewWillAppear(navigationBar: self.navigationController?.navigationBar,
                                          navigationItem: self.navigationItem,
                                          tabBarController: self.tabBarController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bindSingleLocationToCurrLocation(locationManager: self.locationManager, subject: self._currLocation)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchView.viewWillDisappear()
    }
    
}

// MARK: UISearchControllerDelegate
extension LCSearchController {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        // do nothing
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        // do nothing
    }
    
}

// MARK: UISearchBarDelegate
extension LCSearchController {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self._searchText.onNext(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // do nothing
    }
    
}

// MARK: BindCurrLocationSearchTextToShowedMapItems
extension LCSearchController {
    
    func bindCurrLocationSearchTextToShowedMapItems(observable: Observable<(CLLocation, String)>,
                                                    subject: BehaviorSubject<[MKMapItem]>) {
        observable
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .flatMap(self.locationWillSearch(combined:))
            .bind(to: subject)
            .disposed(by: self.disposeBag)
    }
    
    private func locationWillSearch(combined: (CLLocation, String)) -> Observable<[MKMapItem]> {
        return Observable.create { (observer) -> Disposable in
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = combined.1
            searchRequest.region = MKCoordinateRegion(center: combined.0.coordinate,
                                                      latitudinalMeters: 8000,
                                                      longitudinalMeters: 8000)
            searchRequest.pointOfInterestFilter = .includingAll
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                if error != nil {
                    observer.onNext([])
                    return
                }
                guard let response = response else { return }
                observer.onNext(response.mapItems)
            }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
}

// MARK: BindShowedMapItemsToTableView
extension LCSearchController {
    
    func bindShowedMapItemsToTableView(observable: Observable<[MKMapItem]>, tableView: UITableView) {
        let dataSource = self.makeTableViewDataSource()
        observable
            .asDriver(onErrorJustReturn: [])
            .map({ [SectionModel(model: "", items: $0)] })
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func makeTableViewDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, MKMapItem>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MKMapItem>>
        { (_, _, _, item) -> UITableViewCell in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SubtitleTableCell")
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.placemark.title
            return cell
        }
        return dataSource
    }
    
}

// MARK: BindSingleLocationToCurrLocation
extension LCSearchController {
    
    func bindSingleLocationToCurrLocation(locationManager: CLLocationManager, subject: PublishSubject<CLLocation>) {
        locationManager.rx
            .location
            .asDriver(onErrorJustReturn: nil)
            .compactMap({ $0 })
            .drive(subject)
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: BindTableViewModelSelectedToViewModel
extension LCSearchController {
    
    func bindTableViewModelSelectedToViewModel(tableView: UITableView, viewModel: LCSearchViewModel) {
        tableView.rx
            .modelSelected(MKMapItem.self)
            .asDriver()
            .drive(onNext: { [unowned self, unowned viewModel] (mapItem) in
                self.dismiss(animated: true)
                viewModel.doSelect(mapItem: mapItem)
            })
            .disposed(by: self.disposeBag)
    }
    
}

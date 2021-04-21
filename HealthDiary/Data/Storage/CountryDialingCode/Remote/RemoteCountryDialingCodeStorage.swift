//
//  RemoteCountryDialingCodeStorage.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation
import RxSwift

// MARK: RemoteCountryDialingCodeStorage
public protocol RemoteCountryDialingCodeStorage {
    
    func fetchAllInRemote() -> Observable<[CountryDialingCodeDomain]>
    
}

// MARK: DefaultRemoteCountryDialingCodeStorage
public class DefaultRemoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage {
    
    public init() {
    }
    
}

extension DefaultRemoteCountryDialingCodeStorage {
    
    public func fetchAllInRemote() -> Observable<[CountryDialingCodeDomain]> {
        return Observable.create { (observer) -> Disposable in
            let filePath = Bundle.main.path(forResource: "CountryDialingCode", ofType: "json")!
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                let responses = try JSONDecoder().decode([RemoteCountryDialingCodeEntity.Response].self, from: data)
                let domains = responses.map { $0.toDomain() }
                observer.onNext(domains)
                observer.onCompleted()
            } catch {
                observer.onError(error)
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribeOn(ConcurrentMainScheduler.instance)
    }
    
}

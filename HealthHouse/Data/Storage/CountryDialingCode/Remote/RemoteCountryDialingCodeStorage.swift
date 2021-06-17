//
//  RemoteCountryDialingCodeStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation
import RxSwift

// MARK: RemoteCountryDialingCodeStorage
public protocol RemoteCountryDialingCodeStorage {
    
    func fetchAllInRemote() -> Single<[CountryDialingCodeDomain]>
    
}

// MARK: DefaultRemoteCountryDialingCodeStorage
public class DefaultRemoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage {
    
    public init() {
    }
    
}

extension DefaultRemoteCountryDialingCodeStorage {
    
    public func fetchAllInRemote() -> Single<[CountryDialingCodeDomain]> {
        return Single.create { (observer) -> Disposable in
            let filePath = Bundle.main.path(forResource: "CountryDialingCode", ofType: "json")!
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                let responses = try JSONDecoder().decode([RemoteCountryDialingCodeEntity.Response].self, from: data)
                let domains = responses.map { $0.toDomain() }
                observer(.success(domains))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(on: ConcurrentMainScheduler.instance)
    }
    
}

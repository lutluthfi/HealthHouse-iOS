//
//  DefaultCountryDialingCodeRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation
import RxSwift

final class DefaultCountryDialingCodeRepository {
    
    let remoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage
    
    public init(remoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage) {
        self.remoteCountryDialingCodeStorage = remoteCountryDialingCodeStorage
    }
    
}

extension DefaultCountryDialingCodeRepository: CountryDialingCodeRepository {
    
    func fetchAllCountryDialingCode(in storagePoint: StoragePoint) -> Single<[CountryDialingCodeDomain]> {
        switch storagePoint {
        case .realm:
            return StoragePoint.makeCoreDataStorageNotSupported(class: CountryDialingCodeRepository.self,
                                                                function: "fetchAllCountryDialingCode()",
                                                                object: [CountryDialingCodeDomain].self)
        case .remote:
            return self.remoteCountryDialingCodeStorage.fetchAllInRemote()
        case .userDefaults:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: CountryDialingCodeRepository.self,
                                                                   function: "fetchAllCountryDialingCode()",
                                                                   object: [CountryDialingCodeDomain].self)
        }
    }
    
}

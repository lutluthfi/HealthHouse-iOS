//
//  DefaultCountryDialingCodeRepository.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation
import RxSwift

public final class DefaultCountryDialingCodeRepository {
    
    let remoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage
    
    public init(remoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage) {
        self.remoteCountryDialingCodeStorage = remoteCountryDialingCodeStorage
    }
    
}

extension DefaultCountryDialingCodeRepository: CountryDialingCodeRepository {
    
    public func fetchAllCountryDialingCode(in storagePoint: StoragePoint) -> Observable<[CountryDialingCodeDomain]> {
        switch storagePoint {
        case .coreData:
            return StoragePoint.makeCoreDataStorageNotSupported(class: CountryDialingCodeRepository.self,
                                                                function: "fetchAllCountryDialingCode()",
                                                                object: [CountryDialingCodeDomain].self)
        case .remote:
            return self.remoteCountryDialingCodeStorage.fetchAllInRemote()
        case .userDefault:
            return StoragePoint.makeUserDefaultStorageNotSupported(class: CountryDialingCodeRepository.self,
                                                                   function: "fetchAllCountryDialingCode()",
                                                                   object: [CountryDialingCodeDomain].self)
        }
    }
    
}

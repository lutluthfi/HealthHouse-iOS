//
//  CountryDialingCodeRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation
import RxSwift

protocol CountryDialingCodeRepository {
    
    func fetchAllCountryDialingCode(in storagePoint: StoragePoint) -> Single<[CountryDialingCodeDomain]>
    
}

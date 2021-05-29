//
//  AppConfigRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 29/05/21.
//

import Foundation
import RxSwift

public protocol AppConfigRepository {
    
    func fetchFirstLaunch(in storagePoint: StoragePoint) -> Single<Bool>
    
    func insertFirstLaunch(_ firstLaunch: Bool, in storagePoint: StoragePoint) -> Single<Bool>
    
}

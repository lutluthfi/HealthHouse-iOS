//
//  CoreDataLabelStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import RxSwift

public protocol CoreDataLabelStorage {
    
    func fetchAllInCoreData() -> Observable<[LabelDomain]>
    
    func insertIntoCoreData(_ label: LabelDomain) -> Observable<LabelDomain>
    
    func removeInCoreData(_ label: LabelDomain) -> Observable<LabelDomain>
    
}

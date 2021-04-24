//
//  CoreDataProfileStorage.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation
import RxSwift

public protocol CoreDataProfileStorage {
    
    func fetchAllInCoreData() -> Observable<[ProfileDomain]>
    
    func insertIntoCoreData(_ profile: ProfileDomain) -> Observable<ProfileDomain>
    
    func removeInCoreData(_ profile: ProfileDomain) -> Observable<ProfileDomain>
    
}

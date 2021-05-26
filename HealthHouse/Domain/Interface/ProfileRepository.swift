//
//  ProfileRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation
import RxSwift

public protocol ProfileRepository {
    
    func fetchAllProfile(in storagePoint: StoragePoint) -> Observable<[ProfileDomain]>
    
    func fetchProfile(in storagePoint: StoragePoint) -> Observable<ProfileDomain?>
    
    func insertProfile(_ profile: ProfileDomain, into storagePoint: StoragePoint) -> Observable<ProfileDomain>
    
    func removeProfile(_ profile: ProfileDomain, in storagePoint: StoragePoint) -> Observable<ProfileDomain>
    
}

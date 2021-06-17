//
//  ProfileRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation
import RxSwift

protocol ProfileRepository {
    
    func fetchAllProfile(in storagePoint: StoragePoint) -> Single<[Profile]>
    
    func fetchProfile(in storagePoint: StoragePoint) -> Single<Profile?>
    
    func insertProfile(_ profile: Profile, into storagePoint: StoragePoint) -> Single<Profile>
    
    func removeProfile(_ profile: Profile, in storagePoint: StoragePoint) -> Single<Profile>
    
}

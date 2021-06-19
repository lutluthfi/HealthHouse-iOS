//
//  MedicationRealm.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 15/06/21.
//

import Foundation
import RealmSwift

class MedicationRealm: Object {
    
    @objc dynamic var ID: MedicationID = ""
    @objc dynamic var createdAt: Int64 = 0
    @objc dynamic var updatedAt: Int64 = 0
    
    var photoFileNames = List<String>()
    @objc dynamic var dose: String = ""
    @objc dynamic var endedAt: Int64 = 0
    @objc dynamic var location: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var startedAt: Int64 = 0
    
    @objc dynamic var profileID: ProfileID = ""
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
    convenience init(ID: ActivityFlagID,
                     createdAt: Int64,
                     updatedAt: Int64,
                     photoFileNames: [String],
                     dose: String,
                     endedAt: Int64,
                     location: String,
                     name: String,
                     startedAt: Int64,
                     profileID: ProfileID) {
        self.init()
        self.ID = ID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        self.photoFileNames = photoFileNames.toRealm()
        self.dose = dose
        self.endedAt = endedAt
        self.location = location
        self.name = name
        self.startedAt = startedAt
        self.profileID = profileID
    }
    
}

extension MedicationRealm {
    
    func toDomain() -> Medication {
        let profileRealm = self.realm?.object(ofType: ProfileRealm.self, forPrimaryKey: self.profileID)
        let profileDomain = profileRealm!.toDomain()
        return Medication(realmID: self.ID,
                                createdAt: self.createdAt,
                                updatedAt: self.updatedAt,
                                dose: self.dose,
                                endedAt: self.endedAt,
                                location: self.location,
                                name: self.name,
                                photoFileNames: self.photoFileNames.toArray(),
                                startedAt: self.startedAt,
                                profile: profileDomain)
    }
    
}

extension Medication {
    
    func toRealm() -> MedicationRealm {
        return MedicationRealm(ID: self.realmID,
                               createdAt: self.createdAt,
                               updatedAt: self.updatedAt,
                               photoFileNames: self.photoFileNames,
                               dose: self.dose,
                               endedAt: self.endedAt,
                               location: self.location,
                               name: self.name,
                               startedAt: self.startedAt,
                               profileID: self.profile.realmID)
    }
    
}

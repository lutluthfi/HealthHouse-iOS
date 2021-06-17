//
//  ActivityRealm.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 05/06/21.
//

import Foundation
import RealmSwift

@objc final class ActivityRealm: Object {
    
    @objc dynamic var ID: ActivityID = ""
    @objc dynamic var createdAt: Int64 = 0
    @objc dynamic var updatedAt: Int64 = 0
    
    @objc dynamic var doDate: Int64 = 0
    @objc dynamic var explanation: String?
    @objc dynamic var isArchived: Bool = false
    @objc dynamic var isPinned: Bool = false
    @objc dynamic var photoFileNames: [String] = []
    @objc dynamic var title: String = ""
    
    @objc dynamic var profileID: String = ""
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
    convenience init(ID: ActivityID,
                     createdAt: Int64,
                     updatedAt: Int64,
                     doDate: Date,
                     explanation: String?,
                     isArchived: Bool,
                     isPinned: Bool,
                     photoFileNames: [String],
                     title: String,
                     profileID: String) {
        self.init()
        self.ID = ID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        self.doDate = doDate.toInt64()
        self.explanation = explanation
        self.isArchived = isArchived
        self.isPinned = isPinned
        self.photoFileNames = photoFileNames
        self.title = title
        
        self.profileID = profileID
    }
    
}

extension ActivityRealm {
    
    func toDomain() -> Activity {
        let profileRealm = self.realm?.object(ofType: ProfileRealm.self, forPrimaryKey: self.profileID)
        let profileDomain = profileRealm!.toDomain()
        return Activity(realmID: self.ID,
                        createdAt: self.createdAt,
                        updatedAt: self.updatedAt,
                        doDate: self.doDate,
                        explanation: self.explanation,
                        isArchived: self.isArchived,
                        isPinned: self.isPinned,
                        photoFileNames: self.photoFileNames,
                        title: self.title,
                        profile: profileDomain)
    }
    
}

extension Activity {
    
    func toRealm() -> ActivityRealm {
        return ActivityRealm(ID: self.realmID,
                             createdAt: self.createdAt,
                             updatedAt: self.updatedAt,
                             doDate: self.doDate.toDate(),
                             explanation: self.explanation,
                             isArchived: self.isArchived,
                             isPinned: self.isPinned,
                             photoFileNames: self.photoFileNames,
                             title: self.title,
                             profileID: self.profile.realmID)
    }
    
}

extension Array where Element == ActivityRealm {
    
    func toDomain() -> [Activity] {
        return self.compactMap({ $0.toDomain() })
    }
    
}

//
//  Medication.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation

typealias MedicationID = String

struct Medication: EntityDomain {
    
    let realmID: MedicationID
    let createdAt: Int64
    let updatedAt: Int64
    
    let dose: String
    let endedAt: Int64
    let location: String
    let name: String
    let photoFileNames: [String]
    let startedAt: Int64
    
    let profile: Profile
    
    var photoFileUrls: [URL] {
        let directoryURL = FileKit.local.localAttachmentsDirectoryURL
        let urls = self.photoFileNames.map { directoryURL.appendingPathComponent($0, isDirectory: false) }
        return urls
    }
    
}

extension Medication: Equatable {
 
    static func == (lhs: Medication, rhs: Medication) -> Bool {
        return lhs.realmID == rhs.realmID
    }
    
}

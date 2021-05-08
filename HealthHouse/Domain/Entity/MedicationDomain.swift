//
//  MedicationDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation

public struct MedicationDomain: EntityDomain {
    
    public let coreID: CoreID?
    public let createdAt: Int64
    public let updatedAt: Int64
    
    public let dose: String
    public let endedAt: Int64
    public let location: String
    public let name: String
    public let photoFileNames: [String]
    public let startedAt: Int64
    
    public let profile: ProfileDomain
    
    public var photoFileUrls: [URL] {
        let directoryURL = FileKit.local.localAttachmentsDirectoryURL
        let urls = self.photoFileNames.map { directoryURL.appendingPathComponent($0, isDirectory: false) }
        return urls
    }
    
}

extension MedicationDomain: Equatable {
 
    public static func == (lhs: MedicationDomain, rhs: MedicationDomain) -> Bool {
        return lhs.coreID == rhs.coreID
    }
    
}

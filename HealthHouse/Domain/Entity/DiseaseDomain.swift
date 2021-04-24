//
//  DiseaseDomain.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation

public struct DiseaseDomain: EntityDomain {
    
    public let coreID: CoreID?
    public let createdAt: Int64
    public let updatedAt: Int64
    
    public let doctor: String
    public let photoFileNames: [String]
    public let title: String
    
    public let drugs: [DrugDomain]
    
    public var photoFileUrls: [URL] {
        let directoryURL = FileKit.local.localAttachmentsDirectoryURL
        let urls = self.photoFileNames.map { directoryURL.appendingPathComponent($0, isDirectory: false) }
        return urls
    }
    
}

extension DiseaseDomain: Equatable {
    
    public static func == (lhs: DiseaseDomain, rhs: DiseaseDomain) -> Bool {
        return lhs.coreID == rhs.coreID
    }
    
}

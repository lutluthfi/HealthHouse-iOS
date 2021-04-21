//
//  ActivityDomain.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation

public struct ActivityDomain: EntityDomain {
    
    public let coreID: CoreID?
    public let createdAt: Int64
    public let updatedAt: Int64
    
    public let doDate: Int64
    public let explanation: String
    public let isArchived: Bool
    public let isPinned: Bool
    public let photoFileNames: [String]
    public let title: String
    
    public let profile: ProfileDomain
    
    public var photoFileUrls: [URL] {
        let directoryURL = FileKit.local.localAttachmentsDirectoryURL
        let urls = self.photoFileNames.map { directoryURL.appendingPathComponent($0, isDirectory: false) }
        return urls
    }
    
}

extension ActivityDomain: Equatable {
    
    public static func == (lhs: ActivityDomain, rhs: ActivityDomain) -> Bool {
        return lhs.coreID == rhs.coreID
    }
    
}

extension Array where Element == Array<ActivityDomain> {
    
    func groupByDoDate() -> [String: [ActivityDomain]] {
        
        return [:]
    }
    
}

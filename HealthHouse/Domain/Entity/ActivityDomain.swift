//
//  ActivityDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation
import RxDataSources

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
    
    public var photoFileURLs: [URL] {
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

extension Array where Element == ActivityDomain {
    
    func groupByDoDate() -> [Date: [ActivityDomain]] {
        let grouped = Dictionary(grouping: self) { $0.doDate.toDate() }.sorted { $0.key < $1.key }
        var result: [Date: [ActivityDomain]] = [:]
        for group in grouped {
            result[group.key] = group.value
        }
        return result
    }
    
}

extension ActivityDomain: IdentifiableType {
    
    public typealias Identity = String
    
    public var identity: String {
        return self.coreID!.uriRepresentation().path
    }
    
}

//
//  Activity.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation
import RxDataSources

typealias ActivityID = String

struct Activity: EntityDomain {
    
    let realmID: ActivityID
    let createdAt: Int64
    let updatedAt: Int64
    
    let doDate: Int64
    let explanation: String?
    let isArchived: Bool
    let isPinned: Bool
    let photoFileNames: [String]
    let title: String
    
    let profile: Profile
    
    var photoFileURLs: [URL] {
        let directoryURL = FileKit.local.localAttachmentsDirectoryURL
        let urls = self.photoFileNames.map { directoryURL.appendingPathComponent($0, isDirectory: false) }
        return urls
    }
    
}

extension Activity: Equatable {
    
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.realmID == rhs.realmID
    }
    
}

extension Array where Element == Activity {
    
    func groupByDoDate() -> [Date: [Activity]] {
        let grouped = Dictionary(grouping: self) { $0.doDate.toDate() }.sorted { $0.key < $1.key }
        var result: [Date: [Activity]] = [:]
        for group in grouped {
            result[group.key] = group.value
        }
        return result
    }
    
}

extension Activity: IdentifiableType {
    
    typealias Identity = String
    
    var identity: String {
        return self.realmID
    }
    
}

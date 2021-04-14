//
//  FileKit.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation

public protocol LocalFileKit {
    
    var localAttachmentsDirectoryName: String { get }
    
    var localAttachmentsDirectoryURL: URL { get }
    
    var localDocumentsDirectoryURL: URL { get }
    
    var localProfilePhotosDirectoryName: String { get }
    
    var localProfilePhotosDirectoryURL: URL { get }
    
    func makeLocalAttachmentsDirectory() throws
    
    func makeLocalProfilePhotosDirectory() throws
    
}

public class FileKit {
    
    public static let local: LocalFileKit = FileKit()
    
    private init() {
    }
    
}

extension FileKit: LocalFileKit {
    
    public var localAttachmentsDirectoryURL: URL {
        return self.localDocumentsDirectoryURL.appendingPathComponent(self.localAttachmentsDirectoryName,
                                                                      isDirectory: true)
    }
    
    public var localAttachmentsDirectoryName: String {
        return "Attachments"
    }
    
    public var localDocumentsDirectoryURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public var localProfilePhotosDirectoryName: String {
        return "ProfilePhotos"
    }
    
    public var localProfilePhotosDirectoryURL: URL {
        return self.localDocumentsDirectoryURL.appendingPathComponent(self.localProfilePhotosDirectoryName,
                                                                      isDirectory: true)
    }
    
    public func makeLocalAttachmentsDirectory() throws {
        let directoryPath = self.localAttachmentsDirectoryURL.path
        guard !FileManager.default.fileExists(atPath: directoryPath) else { return }
        try FileManager.default.createDirectory(atPath: directoryPath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
    }
    
    public func makeLocalProfilePhotosDirectory() throws {
        let directoryPath = self.localProfilePhotosDirectoryURL.path
        guard !FileManager.default.fileExists(atPath: directoryPath) else { return }
        try FileManager.default.createDirectory(atPath: directoryPath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
    }
    
}

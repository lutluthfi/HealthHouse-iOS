//
//  RepositoryError.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 30/03/21.
//

import Foundation

public enum RepositoryError {
    case dataTransferService(Error)
    case persistent(Error)
}

extension RepositoryError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .dataTransferService(let error):
            return "RepositoryError DataTransferService -> \(error.localizedDescription)"
        case .persistent(let error):
            return "RepositoryError Persistent -> \(error.localizedDescription)"
        }
    }
    
}

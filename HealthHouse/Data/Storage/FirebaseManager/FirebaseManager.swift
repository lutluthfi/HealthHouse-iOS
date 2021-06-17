//
//  FirebaseManager.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 05/06/21.
//

import Firebase
import Foundation

protocol FirebaseManager {
    
}

final class DefaultFirebaseManager {
    
    static let sharedInstance: FirebaseManager = DefaultFirebaseManager()
    
    private init() {
        FirebaseApp.configure()
    }
    
}

extension DefaultFirebaseManager: FirebaseManager {
    
}

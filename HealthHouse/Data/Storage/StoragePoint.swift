//
//  StoragePoint.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import Foundation
import RxSwift

public enum StoragePoint {
    case realm
    case remote
    case userDefaults
}

public extension StoragePoint {
    
    static func makeCoreDataStorageNotSupported<C, T>(`class`: C.Type, function: String, object type: T.Type) -> Single<T> {
        return Single<T>.create { (observer) -> Disposable in
            let error = PlainError(description: "\(String(describing: `class`)) -> \(function) is not available for Realm")
            observer(.failure(error))
            return Disposables.create()
        }.observe(on: CurrentThreadScheduler.instance)
    }
    
    static func makeRemoteStorageNotSupported<C, T>(`class`: C.Type, function: String, object type: T.Type) -> Single<T> {
        return Single<T>.create { (observer) -> Disposable in
            let error = PlainError(description: "\(String(describing: `class`)) -> \(function) is not available for Remote")
            observer(.failure(error))
            return Disposables.create()
        }.observe(on: CurrentThreadScheduler.instance)
    }
    
    static func makeUserDefaultStorageNotSupported<C, T>(`class`: C.Type, function: String, object type: T.Type) -> Single<T> {
        return Single<T>.create { (observer) -> Disposable in
            let error = PlainError(description: "\(String(describing: `class`)) -> \(function) is not available for UserDefaults")
            observer(.failure(error))
            return Disposables.create()
        }.observe(on: CurrentThreadScheduler.instance)
    }
    
}

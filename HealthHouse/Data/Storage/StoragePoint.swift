//
//  StoragePoint.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import Foundation
import RxSwift

public enum StoragePoint {
    case coreData
    case remote
    case userDefault
}

public extension StoragePoint {
    
    static func makeCoreDataStorageNotSupported<C, T>(`class`: C.Type, function: String, object type: T.Type) -> Observable<T> {
        return Observable<T>.create { (observer) -> Disposable in
            let error = PlainError(description: "\(String(describing: `class`)) -> \(function) is not available for CoreData")
            observer.onError(error)
            observer.onCompleted()
            return Disposables.create()
        }.observe(on: CurrentThreadScheduler.instance)
    }
    
    static func makeRemoteStorageNotSupported<C, T>(`class`: C.Type, function: String, object type: T.Type) -> Observable<T> {
        return Observable<T>.create { (observer) -> Disposable in
            let error = PlainError(description: "\(String(describing: `class`)) -> \(function) is not available for Remote")
            observer.onError(error)
            observer.onCompleted()
            return Disposables.create()
        }.observe(on: CurrentThreadScheduler.instance)
    }
    
    static func makeUserDefaultStorageNotSupported<C, T>(`class`: C.Type, function: String, object type: T.Type) -> Observable<T> {
        return Observable<T>.create { (observer) -> Disposable in
            let error = PlainError(description: "\(String(describing: `class`)) -> \(function) is not available for UserDefaults")
            observer.onError(error)
            observer.onCompleted()
            return Disposables.create()
        }.observe(on: CurrentThreadScheduler.instance)
    }
    
}

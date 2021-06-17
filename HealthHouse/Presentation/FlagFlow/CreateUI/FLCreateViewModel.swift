//
//  FLCreateViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

// MARK: FLCreateViewModelResult
enum FLCreateViewModelResult {
    case createUpdateFlagUseCase(AnyResult<Flag, String>)
}

// MARK: FLCreateViewModelResponse
public struct FLCreateViewModelResponse {
}

// MARK: FLCreateViewModelRequest
public struct FLCreateViewModelRequest {
}

// MARK: FLCreateViewModelRoute
public struct FLCreateViewModelRoute {
}

// MARK: FLCreateViewModelInput
protocol FLCreateViewModelInput {
    func viewDidLoad()
    func doCreate(hexcolor: String, name: String)
}

// MARK: FLCreateViewModelOutput
protocol FLCreateViewModelOutput {
    var result: PublishRelay<FLCreateViewModelResult> { get }
}

// MARK: FLCreateViewModel
protocol FLCreateViewModel: FLCreateViewModelInput, FLCreateViewModelOutput { }

// MARK: DefaultFLCreateViewModel
final class DefaultFLCreateViewModel: FLCreateViewModel {

    // MARK: DI Variable
    let request: FLCreateViewModelRequest
    let response: FLCreateViewModelResponse
    let route: FLCreateViewModelRoute

    // MARK: UseCase Variable
    let createUpdateFlagUseCase: CreateFlagUseCase

    // MARK: Common Variable
    let disposeBag = DisposeBag()

    // MARK: Output ViewModel
    let result = PublishRelay<FLCreateViewModelResult>()

    // MARK: Init Function
    init(request: FLCreateViewModelRequest,
         response: FLCreateViewModelResponse,
         route: FLCreateViewModelRoute,
         createFlagUseCase: CreateFlagUseCase) {
        self.request = request
        self.response = response
        self.route = route
        self.createUpdateFlagUseCase = createFlagUseCase
    }
    
}

// MARK: Input ViewModel
extension DefaultFLCreateViewModel {
    
    func viewDidLoad() {
    }
    
    func doCreate(hexcolor: String, name: String) {
        let request = CreateFlagUseCaseRequest(realmID: nil, hexcolor: hexcolor, name: name)
        self.createUpdateFlagUseCase
            .execute(request)
            .subscribe(onSuccess: { [unowned self] (response) in
                let flag = response.flag
                let success = AnyResult<Flag, String>.success(flag)
                let result = FLCreateViewModelResult.createUpdateFlagUseCase(success)
                self.result.accept(result)
            }, onFailure: { [unowned self] (error) in
                let message = error.localizedDescription
                let failure = AnyResult<Flag, String>.failure(message)
                let result = FLCreateViewModelResult.createUpdateFlagUseCase(failure)
                self.result.accept(result)
            })
            .disposed(by: self.disposeBag)
    }
    
}

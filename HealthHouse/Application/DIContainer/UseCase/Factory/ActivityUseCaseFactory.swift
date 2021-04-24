//
//  ActivityUseCaseFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 21/04/21.
//

import Foundation

public protocol ActivityUseCaseFactory {
    
    func makeCreateActivityUseCase() -> CreateActivityUseCase
    
    func makeFetchAllActivityUseCase() -> FetchAllActivityUseCase
    
}

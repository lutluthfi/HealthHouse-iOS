//
//  AnyResult.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/04/21.
//  Copyright (c) 2021. All rights reserved.

import Foundation

public enum AnyResult<Success, Failure> {
    case failure(Failure)
    case success(Success)
}

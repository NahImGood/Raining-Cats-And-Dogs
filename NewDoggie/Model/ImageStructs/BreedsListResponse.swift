//
//  BreedsListResponse.swift
//  NewDoggie
//
//  Created by Eli Warner on 3/5/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation

struct BreedsListResponse: Codable {
    let status: String
    let message: [String: [String]]
}


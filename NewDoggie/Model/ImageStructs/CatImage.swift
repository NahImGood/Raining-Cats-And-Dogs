//
//  CatImage.swift
//  NewDoggie
//
//  Created by Eli Warner on 3/4/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation

struct CatImage: Codable {
    let id: String
    let url: String
    let breeds: [String]
}

//
//  DogImage.swift
//  NewDoggie
//
//  Created by Eli Warner on 3/2/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation

struct DogImage: Codable {
    
    let status: String
    let message: String

}

struct AllImages: Codable {
    let message: [URL]
}

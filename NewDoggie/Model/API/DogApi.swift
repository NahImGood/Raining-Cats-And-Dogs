//
//  DopApi.swift
//  NewDoggie
//
//  Created by Eli Warner on 3/2/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation
import UIKit

class DogAPI {
    
    enum endPoint {
        case randomImage
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImage:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestBreedList(completionHandler: @escaping ([String], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: endPoint.listAllBreeds.url) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            
                let breedsResponse = try! decoder.decode(BreedsListResponse.self, from: data)
                let breeds = breedsResponse.message.keys.map({$0})

            completionHandler(breeds, nil)

        }
        task.resume()
    }
    
    class func requestImage(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        })
        task.resume()
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void){
        let randomImage = DogAPI.endPoint.randomImageForBreed(breed).url
        
        let task = URLSession.shared.dataTask(with: randomImage) { (data, response , error) in
            guard let data = data else {
                completionHandler(nil, error)
                print("There was no data recieved")
                return
            }
            
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            completionHandler(imageData,nil)
        }
        task.resume()

    }
    
    class func requestRandomImage(completionHandler: @escaping (DogImage?, Error?) -> Void){
        let randomImage = DogAPI.endPoint.randomImage.url
        
        let task = URLSession.shared.dataTask(with: randomImage) { (data, response , error) in
            guard let data = data else {
                completionHandler(nil, error)
                print("There was no data recieved")
                return
            }
            
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            completionHandler(imageData,nil)
        }
        task.resume()
        
    }
}

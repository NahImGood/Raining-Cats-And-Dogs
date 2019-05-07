//
//  catAPI.swift
//  NewDoggie
//
//  Created by Eli Warner on 4/20/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation
import UIKit

class CatAPI {
    
    static var catAPIKey = "e1526f67-930c-4127-958d-a42570c5de0b"
    static var catAPIUniqyeUserId = "rw40wx"
    
    enum endpoint: String {
        case randomImage = "https://api.thecatapi.com/v1/images/search"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    class func requestCatImage(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
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
    
    class func requestRandomCatImage(completionHandler: @escaping (String?, String?, Error?) -> Void){
        let randomImage = endpoint.randomImage.url
        var request = URLRequest(url: randomImage)
        request.httpMethod = "GET"
        request.addValue(CatAPI.catAPIKey, forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: randomImage) { (data, response , error) in
            guard let data = data else {
                completionHandler("","", error)
                print("There was no data recieved")
                return
            }
            print(data)
            do{
                var ser = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:AnyObject]]
                if let url = ser[0]["url"] as? String {
                    
                    let last4 = String(url.suffix(3))
                    print(last4)
                    if last4 == "gif"{
                        var gif = "gif"
                        completionHandler(gif, url, nil)
                    }else{
                        var gif = ""
                        completionHandler(gif, url, nil)
                    }
                }
            }catch {
                completionHandler(nil, nil,error)
                print(error)
            }
        }
        task.resume()
    }
    
}




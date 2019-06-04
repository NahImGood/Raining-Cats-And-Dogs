//
//  CatImage.swift
//  NewDoggie
//
//  Created by Eli Warner on 3/4/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation
import UIKit


struct CatImage {
    let type: String
    let url: URL
    let image: UIImage
    
    init(type: String, url: URL, image: UIImage) {
        self.type = type
        self.url = url
        self.image = image
    }
}


/*
class CatImageAsset {
    
    let indexPath: Int
    var url: URL
    let session: URLSession
    let delegate: ImageTaskDownloadedDelegate
    
    var image: UIImage
    
    private var task: URLSessionDownloadTask?
    private var resumeData: Data?
    
    private var isDownloading = false
    private var isFinishedDownloading = false
    
    
    func downLoadImage() {
        if !isFinishedDownloading {
            CatAPI.requestRandomCatImage { (data, error) in
                let url2 = URL(string: data!)
                let gifType = String(data!.suffix(3))
                CatAPI.requestCatImage(url: url2!, completionHandler: { (image, error) in
                    guard let image = image else {
                        print("Error:\(error)")
                        return
                    }
                    self.url = url2!
                    self.image = image
                })
            }
        }
    }
    
    func pause() {
        if isDownloading && !isFinishedDownloading {
            // TODO: Add pause code
            
            self.isDownloading = false
        }
    }
    
    private func downloadTaskCompletionHandler(url: URL?, response: URLResponse?, error: Error?) {
        // TODO: Add code to handle download complete task
        
        self.isFinishedDownloading = true
    }
    
    
}
*/

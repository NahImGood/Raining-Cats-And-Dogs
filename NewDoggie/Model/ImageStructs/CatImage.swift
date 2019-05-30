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


class CatImageAsset {
    
    let indexPath: Int
    let url: URL
    let session: URLSession
    let delegate: ImageTaskDownloadedDelegate
    
    var image: UIImage
    
    private var task: URLSessionDownloadTask?
    private var resumeData: Data?
    
    private var isDownloading = false
    private var isFinishedDownloading = false
    
    init(position: Int, url: URL, session: URLSession, delegate: ImageTaskDownloadedDelegate) {
        self.position = position
        self.url = url
        self.session = session
        self.delegate = delegate
    }
    
    func resume() {
        if !isDownloading && !isFinishedDownloading {
            isDownloading = true
            
            
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

//
//  FavoritesColView.swift
//  NewDoggie
//
//  Created by Eli Warner on 6/1/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit

class FavoritesColView: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func startLoading(){
        activityIndicator.startAnimating()
    }
    
    func stopLoading(){
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        imageView.alpha = 1
    }
}

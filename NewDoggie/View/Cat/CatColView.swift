//
//  CatColView.swift
//  NewDoggie
//
//  Created by Eli Warner on 4/20/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit

class CatColView: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    let imageLoading = CGFloat(0.5)
    

    func startLoading(){
        activityIndicator.startAnimating()
        imageView.alpha = imageLoading
        imageView.image = UIImage(named: "placeholderimage")
    }
    
    func stopLoading(){
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        imageView.alpha = 1
    }
}

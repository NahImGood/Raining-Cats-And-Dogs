//
//  DetailVC.swift
//  NewDoggie
//
//  Created by Eli Warner on 6/4/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        imageView.image = image
    }
    
}


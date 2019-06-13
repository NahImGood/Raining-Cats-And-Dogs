//
//  DetailVC.swift
//  NewDoggie
/*
    handles detail view for Images/Gifs
 */
//  Created by Eli Warner on 6/12/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit

class DetailVC: DraggableViewController {

    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    var catAsset: CatImage?
    var dogAsset: DogAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentPassedAsset()
        // Do any additional setup after loading the view.
    }
    
    func presentPassedAsset(){
        if catAsset != nil {
            if catAsset?.type == "gif" { // Is a Gif
                performOn(.Main) {
                    let gif = UIImage.gifImageWithURL(self.catAsset!.url)
                    self.imageView.image = gif
                }
                
            }else { // Not a Gif
                performOn(.Main) {
                    self.imageView.image = self.catAsset?.image
                }
            }
        }
        //Its a dog Image
        if dogAsset != nil {
            print("DogImage")
            performOn(.Main) {
                self.imageView.image = self.dogAsset?.image
            }
        }
    }


}

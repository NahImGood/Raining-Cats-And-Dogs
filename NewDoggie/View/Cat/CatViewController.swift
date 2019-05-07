//
//  CatViewController.swift
//  NewDoggie
//
//  Created by Eli Warner on 4/20/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit

private var reusableID = "CatColID"

class CatViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var collectionImageView: UICollectionView!
    let refreshControl = UIRefreshControl()


    //MARK: Properties
    var catImages: [UIImage]?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionImageView.delegate = self
        collectionImageView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateCatImages()
    }
    
    func populateCatImages(){
        for i in 0...30 {
            getCatImage()
        }
    }
    
    func handleCatImageResponse(image: UIImage?, error: Error?){
        catImages?.append(image!)
    }
    
    func handleCatGifResponse(image: UIImage){
        catImages?.append(image)
    }
    
    func getCatImage(){
        CatAPI.requestRandomCatImage { (type, url, error)  in
            guard let url = url else {
                print("No URl")
                return
            }
            print(url)
            if type == "gif"{
                let gif = UIImage.gifImageWithURL(url)
                self.handleCatGifResponse(image: gif!)
            }else {
                guard let temp = URL(string: url) else {
                    return
                }
                CatAPI.requestCatImage(url: temp, completionHandler: self.handleCatImageResponse(image:error:))
            }
        }
    }
}

    //MARK: CollectionView Extension
extension CatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: Return number of cat images.
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableID, for: indexPath) as! CatColView
        cell.activityIndicator.startAnimating()
        DispatchQueue.main.async {
        CatAPI.requestRandomCatImage { (type, url, error)  in
            guard let url = url else {
                print("No URl")
                return
            }
            print(url)
            if type == "gif"{
                let gif = UIImage.gifImageWithURL(url)
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    cell.imageView.image = gif
                }
            }else {
                var temp = URL(string: url)
                CatAPI.requestCatImage(url: temp!, completionHandler: { (image, error) in
                    guard let image = image else {
                        return
                    }
                    DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                        cell.imageView.image = image
                    }
                })
            }
        }
            
        }

        return cell
    }
}

//MARK: Pull to reload
extension CatViewController {
    
}

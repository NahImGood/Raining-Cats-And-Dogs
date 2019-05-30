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
    var catImages: [CatImage]?
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 5.0,
                                             left: 10.0,
                                             bottom: 5.0,
                                             right: 10.0)
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        collectionImageView.delegate = self
        collectionImageView.dataSource = self
        //loadImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
    }
    
    func loadImages(){
        print("Images loaded")
        print(catImages?.count)
        collectionImageView.reloadData()
    }
    
}

    //MARK: CollectionView Extension
extension CatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: Return number of cat images.

            return catImages?.count ?? 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableID, for: indexPath) as! CatColView
            cell.startLoading()
        
        if let image = catImages?[indexPath.row] {
            
            switch self.decideImageType(string: image.type) {
            case true:
                let gif = UIImage.gifImageWithURL(image.url)
                DispatchQueue.main.async {
                    cell.stopLoading()
                    cell.imageView.image = gif
                }
            case false:
                DispatchQueue.main.async {
                    cell.imageView.image = image.image
                    cell.stopLoading()
                }
                
            }
            print(" Image is real")
        } else {
            CatAPI.requestRandomCatImage { (data, error) in
                let url = URL(string: data!)
                let last4 = String(data!.suffix(3))
                CatAPI.requestCatImage(url: url!, completionHandler: { (image, error) in
                    guard let image = image else {
                        print("Error:\(error)")
                        return
                    }
                    let catAsset = CatImage(type: last4, url: url!, image: image)
                    
                    self.catImages?.append(catAsset)
                    
                    switch self.decideImageType(string: catAsset.type) {
                    case true:
                        let gif = UIImage.gifImageWithURL(catAsset.url)
                        DispatchQueue.main.async {
                            cell.stopLoading()
                            cell.imageView.image = gif
                        }
                    case false:
                        DispatchQueue.main.async {
                            cell.imageView.image = catAsset.image
                            cell.stopLoading()
                        }
                        
                    }
                })
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Begin asynchronously fetching data for the requested index paths.
        
        
    }

    
    func decideImageType(string: String)-> Bool{
        return ( string == "gif")
    }
}

//MARK: Pull to reload
extension CatViewController: UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

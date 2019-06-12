//
//  CatViewController.swift
//  NewDoggie
//
//  Created by Eli Warner on 4/20/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit
import CoreData

private var reusableID = "CatColID"

class CatViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var collectionImageView: UICollectionView!
    let refreshControl = UIRefreshControl()
    let activityView = UIActivityIndicatorView(style: .gray)
    //MARK: Properties
    var catImages: [CatImage] = []
    var loadingData: Bool = false
    var selectedImage: CatImage?
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 5.0,
                                             left: 10.0,
                                             bottom: 5.0,
                                             right: 10.0)
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionImageView.delegate = self
        collectionImageView.dataSource = self
        load20Images()
        activity()
    }
    
    func activity(){
        let fadeView:UIView = UIView()
        
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        // start animating activity view
        activityView.startAnimating()
    }
    //MARK - Loading Images
    func load20Images(){
        var i = 0
        
        for _ in i...15 {
            self.loadImage()
            i = i + 1
        }
        loadingData = false
    }
    
    func loadImage(){
        let catCount = catImages.count + 14
        performOn(.Background){
            CatAPI.completeCatDataCall { (asset, error) in
                guard let asset = asset else {
                    self.collectionImageView.setEmptyMessage("Trouble loading Data")
                    print(error?.localizedDescription)
                    return
                }
                self.catImages.append(asset)
                if self.catImages.count > catCount {
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.collectionImageView.reloadData()
                    }
                }
            }
        }
    }
}

    //MARK: CollectionView Extension
extension CatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastimage = catImages.count - 2
        if !loadingData && indexPath.row == lastimage {
            loadingData = true
            load20Images()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if catImages.count == 0 {
            self.collectionImageView.setEmptyMessage("Wait while we load some kitties! :)")
        return catImages.count
        } else {
            self.collectionImageView.setEmptyMessage("")
        return catImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableID, for: indexPath) as! CatColView
            cell.startLoading()
        let image = catImages[indexPath.row]
        
            //because some are gifs, we use a different image loader for gifs.
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
        
        return cell
    }
    
    func save(asset: CatImage) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CatData", in: managedContext)!
        
        let catImage = NSManagedObject(entity: entity, insertInto: managedContext)
        
        catImage.setValue(asset.image.pngData(), forKeyPath: "data")
        catImage.setValue(asset.url, forKey: "url")
        catImage.setValue(asset.type, forKey: "type")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func decideImageType(string: String)-> Bool{
        return ( string == "gif")
    }
    
    
}

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        save(asset: catImages[indexPath.row])
    }
}



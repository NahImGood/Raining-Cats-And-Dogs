//
//  FavoritesVC.swift
//  NewDoggie
//
//  Created by Eli Warner on 6/1/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit
import CoreData

class FavoritesVC: DraggableViewController , UICollectionViewDataSource, UICollectionViewDelegate {

    //MARK - Variables
    var catImages: [CatImage] = []
    var dogImages: [DogAsset] = []
    var detailVCPassedAssetCat: CatImage?
    var detailVCPassedAssetDog: DogAsset?
    var catOrDog = false //False for cat, true for dog
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 5.0,
                                             left: 10.0,
                                             bottom: 5.0,
                                             right: 10.0)
    //MARK: - Outlets
    @IBOutlet weak var favCollectionView: UICollectionView!
    @IBOutlet weak var favSwapButton: UIButton!
    
    //MARK: - Actions
    @IBAction func favSwapButton(_ sender: Any) {
        switch catOrDog {
        case true:
            catOrDog = false
        case false:
            catOrDog = true
        }
        setUPButtonName()
        favCollectionView.reloadData()
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCoreData()
        setUpCollectionView()
        setUPButtonName()
        LongPressPopUpView(view: favCollectionView)
        // Do any additional setup after loading the view.
    }
    
    func setUpCollectionView(){
        favCollectionView.dataSource = self
        favCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpCoreData()
    }
    
    func setUPButtonName(){
        switch catOrDog {
        case true:
            favSwapButton.setTitle("Cats!", for: .normal)
        case false:
            favSwapButton.setTitle("Dogs!", for: .normal)
        }
    }
    
    
    //MARK - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch catOrDog {
        case true:
            if dogImages.count == 0 {
                self.favCollectionView.setEmptyMessage("You don't seem to have any saved dog pics!")
                return dogImages.count
            } else {
                self.favCollectionView.setEmptyMessage("")
                return dogImages.count
            }
        case false:
            if catImages.count == 0 {
                self.favCollectionView.setEmptyMessage("You don't seem to have any saved cat pics!")
                return catImages.count
            } else {
                self.favCollectionView.setEmptyMessage("")
                return catImages.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavCell", for: indexPath) as! FavoritesColView
        switch catOrDog {
        case true:
            //Dog Image
            let image = dogImages[indexPath.row].image
            cell.imageView.image = image
        case false:
            //Cat Image
            let image = catImages[indexPath.row]
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
        }
        
        return cell
    }
    
    func decideImageType(string: String)-> Bool{
        return ( string == "gif")
    }

    


}

//MARK: Pull to reload
extension FavoritesVC: UICollectionViewDelegateFlowLayout {
    
    //MARK: - Longpress Detail
    //Set up of longpress function for implementaion in ViewDidLoad
    func LongPressPopUpView(view: UIView) {
        let longPressPopUp = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressPopUp.delegate = self
        longPressPopUp.delaysTouchesBegan = true
        favCollectionView.addGestureRecognizer(longPressPopUp)
        
        longPressPopUp.minimumPressDuration = 0.5
        
    }
    
    //What the long press func gets whe pressed
    @objc func longPress(sender: UITapGestureRecognizer){
        let location = sender.location(in: favCollectionView)
        let indexPath = favCollectionView.indexPathForItem(at: location)
        
        guard let row = indexPath?.row else {
            return
        }
        
        if sender.state == .began {// same for other states .failed .cancelled {
            switch catOrDog {
            case true:
                detailVCPassedAssetDog = dogImages[row]
                performSegue(withIdentifier: "detailVC", sender: nil)

            case false:
                detailVCPassedAssetCat = catImages[row]
                performSegue(withIdentifier: "detailVC", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            let vc = segue.destination as! DetailVC
            switch catOrDog {
            case true:
                vc.dogAsset = detailVCPassedAssetDog
                
            case false:
                vc.catAsset = detailVCPassedAssetCat
            }
        }
    }
    
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

//MARK: = CoreData

extension FavoritesVC {
    
    func setUpCoreData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CatData")
        let dogFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DogData")
        
        //Grab CatData
        do {
            let results = try? managedContext.fetch(fetchRequest)
            catImages = []
            for asset in results as! [NSManagedObject] {
                let type =  asset.value(forKey: "type") as! String
                let data = asset.value(forKey: "data") as! Data
                let url = asset.value(forKey: "url") as! NSURL
                let catImage = CatImage(type: type, url: url as URL, image: UIImage(data: data)!)
                catImages.append(catImage)
            }
            favCollectionView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        //Grab Dog Data
        do {
            let results = try? managedContext.fetch(dogFetchRequest)
            dogImages = []
            for asset in results as! [NSManagedObject] {
                let image = asset.value(forKey: "data") as! Data
                let dogAsset = DogAsset(image: UIImage(data: image)!)
                dogImages.append(dogAsset)
            }
            favCollectionView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }// end of setUpCoreDate()
}

//
//  DogViewController.swift
//  NewDoggie
//
//  Created by Eli Warner on 4/23/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit

class DogViewController: UIViewController {

    //MARK: Properties
    private var reuseIdentifier = "dogcell"
    var breeds: [String]  = []
    var imagePickerRow: Int = 0
    
    //MARK: Outlets
    @IBOutlet weak var collectionImageView: UICollectionView!
    @IBOutlet weak var imagePicker: UIPickerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializers()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DogAPI.requestBreedList(completionHandler: handleBreedsListResponse(breeds:error:))
        print(breeds)
    }
    
    func initializers(){
        collectionImageView.delegate = self
        collectionImageView.dataSource = self
        imagePicker.dataSource = self
        imagePicker.delegate = self
    }
    
    func handleBreedsListResponse(breeds: [String], error: Error?){
        self.breeds = breeds
        DispatchQueue.main.async {
            self.imagePicker.reloadAllComponents()
        }
    }

}

extension DogViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        DogAPI.requestBreedList(completionHandler: handleBreedsListResponse(breeds:error:))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DogColView
        cell.activityIndicator.startAnimating()
        if imagePickerRow != nil {
        DogAPI.requestRandomImage(breed: breeds[imagePickerRow]) { (image, error) in
            guard let image = image?.message else {
                return
            }
            let url = URL(string: image)
            DogAPI.requestImage(url: url!, completionHandler: { (response, error) in
                DispatchQueue.main.async {
                     cell.activityIndicator.startAnimating()
                    cell.imageView.image = response
                }
            })
        }
        }else {
            DogAPI.requestRandomImage { (image, error) in
                guard let image = image?.message else {
                    return
                }
                let url = URL(string: image)
                DogAPI.requestImage(url: url!, completionHandler: { (response, error) in
                    DispatchQueue.main.async {
                        cell.activityIndicator.stopAnimating()
                        cell.imageView.image = response
                    }
                })
            }
        }
        
        return cell
    }
    
    
}

extension DogViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        imagePickerRow = row
    }
}

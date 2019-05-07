//
//  ViewController.swift
//  NewDoggie
//
//  Created by Eli Warner on 2/28/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var imagePicker: UIPickerView!
    
    //MARK: Variables
    var breeds: [String]  = []
    var imagePickerRow: Int = 0
    var allImages: [String] = []
    
    //MARK: Actions
    @IBOutlet weak var displayNewDogImage: UIImageView!
    
    @IBAction func backImageButtonPressed(_ sender: Any) {
        
    }
    @IBAction func nextImageButtonPressed(_ sender: Any) {
        
    }
    @IBAction func fetchNewDogImageButton(_ sender: Any) {

        DogAPI.requestRandomImage(breed: breeds[imagePickerRow], completionHandler: handleRandomImageResponse(dogImage:error:))
       
    }
    
    @IBAction func fetchNewDogImageButtonTopPreseed(_ sender: Any) {
        //getCatImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.dataSource = self
        imagePicker.delegate = self
        DogAPI.requestBreedList(completionHandler: handleBreedsListResponse(breeds:error:))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! AllImageViewController
           // detailVC.Images = allImages
        }
    }
    
    //MARK: Handlers
    
    func handleRandomImageResponse(dogImage: DogImage?, error: Error?){
        guard let imagedata = dogImage?.message else {
            return
        }
        allImages.append(imagedata)
        let url = URL(string: imagedata)
        DogAPI.requestImage(url: url!, completionHandler: self.handleImageFileResponse(image: error:))
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?){
        DispatchQueue.main.async {
            self.displayNewDogImage.image = image
        }
    }
    
    func handleBreedsListResponse(breeds: [String], error: Error?){
        self.breeds = breeds
        DispatchQueue.main.async {
            self.imagePicker.reloadAllComponents()
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: handleRandomImageResponse(dogImage:error:))
        imagePickerRow = row
    }
}


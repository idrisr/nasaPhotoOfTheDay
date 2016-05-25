//
//  ViewController.swift
//  nasaPOD
//
//  Created by id on 5/22/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!

    var photos: [Photo]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        Photo.allPhotos() { [weak self] (photos, error) in
            guard error == nil else {
                self?.photos = nil
                self?.collectionView?.reloadData()
                return
            }
            self?.photos = photos
            self?.collectionView?.reloadData()
        }

        self.configureDatePicker()
    }


    @IBAction func datePickerChanged(sender: UIDatePicker) {
        let selectedDate = sender.date
        let index = self.photos!.indexOf { (photo) -> Bool in
            return photo.date! == selectedDate
        }
        
        let indexPath = NSIndexPath(forRow: index!, inSection: 0)
        self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }


    private func configureDatePicker() {
        // FIXME: dont load plist multiple times
        let path = NSBundle.mainBundle().pathForResource("nasaAPI", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: path)!
        let formatter = NSDateFormatter()
        let minimumDateString = dict["minimumDate"] as! String
        formatter.dateFormat = "yyyyMMdd"
        let minimumDate = formatter.dateFromString(minimumDateString)

        self.datePicker.minimumDate = minimumDate
        self.datePicker.maximumDate = NSDate()
        self.datePicker.datePickerMode = .Date
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseID = "photoCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseID, forIndexPath: indexPath) as! PhotoCollectionViewCell

        let photo = photos![indexPath.row]
        print("\(photo.date)")
        cell.photo = photo
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.frame.size.width * 0.9
        let height = collectionView.frame.size.height * 0.9
        return CGSizeMake(width, height)
    }
}

extension ViewController: UICollectionViewDelegate { }
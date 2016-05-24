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
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseID = "photoCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseID, forIndexPath: indexPath) as! PhotoCollectionViewCell
        print("\(indexPath.row)")
        cell.titleLabel.text = "\(indexPath.row)"
        cell.titleLabel.textColor = UIColor.whiteColor()
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 2.0
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    // FIXME: make collection view paging center cell properly
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

extension ViewController: UICollectionViewDelegate { }
//
//  ViewController.swift
//  nasaPOD
//
//  Created by id on 5/22/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

protocol ViewUpdateDelegate {
    func updateView()
}

protocol SaveDateDelegate {
    func saveDate()
    func loadDate()
}

class MasterViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!

    var photos: [Photo]?
    var firstLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveDateDelegate = self

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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstLoad == true {
            self.loadDate()
            firstLoad = false
        }
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let cell = sender as? PhotoCollectionViewCell else {
            return
        }

        let indexPath = self.collectionView.indexPathForCell(cell)
        let photo = self.photos![indexPath!.row]
        let destinationVC = segue.destinationViewController as! DetailViewController
        destinationVC.photo = photo
    }
}

extension MasterViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos!.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseID = "photoCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseID, forIndexPath: indexPath) as! PhotoCollectionViewCell

        let photo = photos![indexPath.row]
        photo.viewUpdateDelegate = self

        guard let _ = photo.url else {
            let apiurl = NasaAPIURL(date: photo.date!.toString()).url()
            cell.dateLabel.text = photo.date!.toString()
            cell.dateLabel.textColor = UIColor.whiteColor()
            NetworkClient.sharedInstance.getURL(apiurl, completion: { (results, error) in
                if let dict = results as! NSDictionary? {
                    photo.updateWithDict(dict)
                }
            })
            return cell
        }

        cell.imageView.image = photo.image
        cell.dateLabel.text = photo.date!.toString()
        cell.dateLabel.textColor = UIColor.whiteColor()
        cell.titleLabel.text = photo.title!
        cell.titleLabel.textColor = UIColor.whiteColor()

        return cell
    }
}

extension MasterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.frame.size.width * 1.0
        let height = collectionView.frame.size.height * 1.0
        return CGSizeMake(width, height)
    }
}

extension MasterViewController: SaveDateDelegate {
    func saveDate() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let cell = self.collectionView.visibleCells().first {
            let indexPath = self.collectionView.indexPathForCell(cell)
            let photo = self.photos![indexPath!.row]
            let string = NSString(string: photo.date!.toString())
            defaults.setObject(string, forKey: "date")
        }
    }

    func loadDate() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let stringDate = defaults.objectForKey("date") {
            let date = (stringDate as! String).toDate()
            let index = self.photos!.indexOf { (photo) -> Bool in
                return photo.date! == date
            }

            if let _ = index {
                let indexPath = NSIndexPath(forRow: index!, inSection: 0)
                self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
            }
        }
    }
}

extension MasterViewController: ViewUpdateDelegate {
    func updateView() {
        self.collectionView.reloadData()
    }
}
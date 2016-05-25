//
//  PhotoCollectionViewCell.swift
//  nasaPOD
//
//  Created by id on 5/22/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

@IBDesignable
class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    var imageTask: NSURLSessionDownloadTask?

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }

    var photo: Photo? {
        didSet {
            // cancel existing download task for cell because it just got reused
            imageTask?.cancel()

            guard photo?.image == nil else {
                self.imageView.image = photo?.image
                return
            }

            guard let date = photo?.date else {
                self.imageView.image = UIImage(named: DefaultImages.broken.rawValue)
                return
            }

            self.titleLabel.text = self.photo!.date?.toString()
            self.titleLabel.textColor = UIColor.whiteColor()

            // dont have the image url yet. make the API call
            guard let _ = photo?.url else {
                let apiurl = NasaAPIURL(date: date.toString()).url()

                NetworkClient.sharedInstance.getURL(apiurl, completion: { [weak self] (results, error) in
                    if let dict = results as! NSDictionary? {
                        self!.photo?.updateWithDict(dict)
                        let imageURL = NSURL(string: self!.photo!.url!)!
                        self?.imageTask = self?.getImage(imageURL)
                    }
                })
                return
            }

            // dont have the image yet. download the image
            guard let _ = photo?.image else {
                switch photo!.media_type! {
                    case .image:
                        imageTask = self.getImage(NSURL(string: self.photo!.url!)!)
                    case .video:
                        imageView.image = UIImage(named: DefaultImages.broken.rawValue)
                }
                return
            }
        }
    }

    private func getImage(imageURL: NSURL) -> NSURLSessionDownloadTask {
        return NetworkClient.sharedInstance.getImage(imageURL, completion: { [weak self] (image, error) in
            guard error == nil else {
                self?.imageView.image = UIImage(named: DefaultImages.broken.rawValue)
                return
            }

            self?.photo?.image = image
            self?.imageView.image = image
        })
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photo = nil
//        imageView.image = nil
//        titleLabel.text = nil
    }
}
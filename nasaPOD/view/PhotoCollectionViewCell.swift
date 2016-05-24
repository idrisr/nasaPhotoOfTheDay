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
        // when cell appears, make its initial api call
        // after that make the photo call
        // if the cell disappears then

        didSet {
            imageTask?.cancel()
            guard let date = photo?.date else {
                self.imageView.image = UIImage(named: "Broken")
                return
            }

            guard let photoUrl = photo?.url else {
                let url = NasaAPIURL(date: date.toString()).url()

                NetworkClient.sharedInstance.getURL(url, completion: { [weak self] (results, error) in
                    if let dict = results as! [String: String]? {
                        self!.photo?.updateWithDict(dict)
                        self?.titleLabel.text = self!.photo!.url
                        print(self?.photo?.url)
                    }
                    })



                return
            }

            let url = NSURL(string: photoUrl)
            imageTask = NetworkClient.sharedInstance.getImage(url!) { [weak self] (image, error) in
                guard error == nil else {
                    self?.imageView.image = UIImage(named: "Broken")
                    return
                }
                self?.imageView.image = image
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photo = nil
    }
}
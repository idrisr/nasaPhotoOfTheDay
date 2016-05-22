//
//  PhotoCollectionViewCell.swift
//  nasaPOD
//
//  Created by id on 5/22/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var imageTask: NSURLSessionDownloadTask?
    var photo: Photo? {
        didSet {
//            imageTask?.cancel()
//            guard let photoUrl = photo?.photoUrl else {
//                self.photoImageView.image = UIImage(named: "Downloading")
//                return
//            }
//
//            imageTask = NetworkClient.sharedInstance.getImage(photoUrl) { [weak self] (image, error) in
//                guard error == nil else {
//                    self?.imageView.image = UIImage(named: "Broken")
//                    return
//                }
//                self?.imageView.image = image
//            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photo = nil
    }
}
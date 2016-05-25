//
//  DetailViewController.swift
//  nasaPOD
//
//  Created by id on 5/25/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var photo: Photo?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = photo?.image
        self.imageView.contentMode = .ScaleAspectFit
        self.textView.text = photo?.explanation
        self.title = photo?.title
    }
}

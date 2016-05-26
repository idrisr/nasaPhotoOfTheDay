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
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = photo?.image
        self.imageView.contentMode = .ScaleAspectFit
        self.textView.text = photo?.explanation
        self.title = photo?.title
        self.spinner.hidesWhenStopped = true

        switch photo!.media_type! {
            case .video:
                let url = NSURL(string: photo!.url!)
                let request = NSURLRequest(URL: url!)
                self.webView.loadRequest(request)
                self.webView.allowsInlineMediaPlayback = true
                self.webView.delegate = self
                self.imageView.hidden = true

            case .image:
                self.imageView.image = photo?.image
                self.imageView.contentMode = .ScaleAspectFit
                self.webView.hidden = true
                self.spinner.hidden = true
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
}

extension DetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        spinner.stopAnimating()
    }

    func webViewDidStartLoad(webView: UIWebView) {
        spinner.startAnimating()
    }
}
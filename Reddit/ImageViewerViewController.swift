//
//  ImageViewerViewController.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import UIKit

class ImageViewerViewController : UIViewController {
    
    public var postModel: PostModel?
    @IBOutlet var imageViewer: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let thumbnailURLString = self.postModel?.data.thumbnail?.absoluteString {
            self.imageViewer?.downloadImage(with: thumbnailURLString)
        }
    }
    
    @IBAction func saveImage(){
        // Save image
    }
}

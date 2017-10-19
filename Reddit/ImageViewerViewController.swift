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
        if let imageURLString = self.postModel?.data.preview?.images![0].source?.url?.absoluteString {
            self.imageViewer?.downloadImage(with: imageURLString)
        }
    }
    
    @IBAction func saveImage(){
        UIImageWriteToSavedPhotosAlbum((self.imageViewer?.image)!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Success!", message: "Your image was saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

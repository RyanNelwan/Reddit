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
    @IBOutlet var activityView: UIActivityIndicatorView?
    @IBOutlet var saveButton: UIButton?
    
    var isLoading: Bool = false {
        didSet {
            self.activityView?.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.postModel != nil {
            self.configureView()
        }
    }
    
    private func configureView() {
        if let imageURLString = self.postModel?.data.preview?.images![0].source?.url?.absoluteString {
            self.imageViewer?.downloadImage(with: imageURLString, completion: {
                // Enable it once download completes
                self.saveButton?.isUserInteractionEnabled = true
                self.isLoading = false
            }) { (error) in
                self.isLoading = false
            }
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

// MARK: App state preserveration and restoration

extension ImageViewerViewController {
    
    override func encodeRestorableState(with coder: NSCoder) {
        if let postModel = self.postModel {
            let encoder = JSONEncoder()
            let encodedModel = try! encoder.encode(postModel)
            coder.encode(encodedModel, forKey: "ImageViewerController_PostModel")
        }
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let restoredPostData = coder.decodeObject(forKey: "ImageViewerController_PostModel") as? Data {
            do {
                let postModel = try JSONDecoder().decode(PostModel.self, from: restoredPostData)
                self.postModel = postModel
                self.configureView()
            } catch {
                print("Could not restore previous state")
            }
        }
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        super.applicationFinishedRestoringState()
    }
}

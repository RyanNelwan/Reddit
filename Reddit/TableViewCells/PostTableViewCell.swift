//
//  PostTableViewCell.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate: class {
    func postTableViewCellDidTap(thumbnailView: UIImageView, inCell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var numberOfCommentsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var thumbnailView: UIImageView!
    
    weak var delegate: PostTableViewCellDelegate?
    var postModel: PostModel?
    
    func configure(_ postModel : PostModel) {
        
        self.postModel = postModel
        
        if let titleString = postModel.data.title {
            self.titleLabel.text = titleString
        }
        if let dateString = postModel.data.dateString() as String? {
            self.dateLabel.text = dateString
        }
        if let authorString = postModel.data.author {
            self.authorLabel.text = authorString
        }
        if let numberOfCommentsString = postModel.data.numberOfCommentsString() as String? {
            self.numberOfCommentsLabel.text = numberOfCommentsString
        }
        self.thumbnailView.image = UIImage()
        if let thumbnailURLString = postModel.data.thumbnail?.absoluteString {
            self.thumbnailView.downloadImage(with: thumbnailURLString)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.thumbnailView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleImageTap(_:))))
    }
    
    // Image tap handler
    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.postTableViewCellDidTap(thumbnailView: self.thumbnailView, inCell: self)
        }
    }
    
    @IBAction func t() {
        print("ASD")
    }
}

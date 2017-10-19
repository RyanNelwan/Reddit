//
//  PostTableViewCell.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var numberOfCommentsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var thumbnailView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbnailView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleImageTap(_:))))
    }
    
    // Image tap handler
    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        print("Open Image")
    }
}

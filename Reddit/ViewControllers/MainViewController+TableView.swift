//
//  MainViewController+TableView.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource, PostTableViewCellDelegate {
    
    func postTableViewCellDidTap(thumbnailView: UIImageView, inCell: PostTableViewCell) {
        if let imageViewerViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewer") as? ImageViewerViewController {
            imageViewerViewController.postModel = inCell.postModel
            self.navigationController?.pushViewController(imageViewerViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.redditModel?.data.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostTableViewCell
        if let postModel = self.redditModel?.data.posts[indexPath.row] {
            cell.configure(postModel)
            cell.delegate = self
        }
        return cell
    }
}

//
//  MainViewController.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var requestManager = RequestManager()
    var dataTask: URLSessionDataTask?
    var redditModel: RedditModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.fetchTopPosts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func fetchMore() {
        self.fetchTopPosts()
    }
    
    func fetchTopPosts() {
        let urlString = self.requestManager.urlString()
        self.dataTask?.cancel()
        
        if let components = URLComponents(string: urlString) {
            guard let url = components.url else { return }
            self.dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    // TODO: display error message
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
                guard let data = data else { return }
                self.handleResponseData(with: data)
            }
        }
        
        self.dataTask?.resume()
    }
    
    func handleResponseData(with data: Data) {
        do {
            let model = try JSONDecoder().decode(RedditModel.self, from: data)
            if self.redditModel == nil {
                self.redditModel = model
            } else {
                self.redditModel?.data.posts.append(contentsOf: model.data.posts)
            }
            if let nextID = model.data.after {
                self.requestManager.nextID = nextID
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            // TODO: handle error accordingly
            print("Error: \(String(describing: error.localizedDescription))")
        }
    }
}

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

extension MainViewController {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    override func applicationFinishedRestoringState() {
        super.applicationFinishedRestoringState()
    }
}

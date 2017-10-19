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
    var isRequesting: Bool = false
    var isRestoring: Bool = false
    
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
        self.isRequesting = true
        
        if let components = URLComponents(string: urlString) {
            guard let url = components.url else { return }
            self.dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                self.isRequesting = false
                
                // Check if we're restoring
                if self.isRestoring {
                    return
                }
                
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

// MARK: UITableView

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

// MARK: App state preserveration and restoration

extension MainViewController {
    
    override func encodeRestorableState(with coder: NSCoder) {
        // Encode model
        if let redditModel = self.redditModel {
            let encoder = JSONEncoder()
            let encodedModel = try! encoder.encode(redditModel)
            coder.encode(encodedModel, forKey: "RedditModel")
        }
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let restoredRedditData = coder.decodeObject(forKey: "RedditModel") as? Data {
            do {
                // Restore our model
                let redditModel = try JSONDecoder().decode(RedditModel.self, from: restoredRedditData)
                self.redditModel = redditModel
                self.isRestoring = true
                if self.isRequesting {
                    self.dataTask?.cancel()
                }
                
                // Restore our nextID for request manager
                if let nextID = redditModel.data.after {
                    self.requestManager.nextID = nextID
                }
            } catch {
                print("Could not restore previous state")
            }
        }
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        self.tableView.reloadData()
        if self.isRestoring {
            self.isRequesting = false
        }
        self.isRestoring = false
        super.applicationFinishedRestoringState()
    }
}

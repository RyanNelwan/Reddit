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
        
        print("Request: \(urlString)")
        
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.redditModel?.data.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostTableViewCell
        let postModel = self.redditModel?.data.posts[indexPath.row]
        
        if let titleString = postModel?.data.title {
            cell.titleLabel.text = titleString
        }
        
        if let dateString = postModel?.data.dateString() {
            cell.dateLabel.text = dateString
        }
        
        if let authorString = postModel?.data.author {
            cell.authorLabel.text = authorString
        }
        
        if let numberOfCommentsString = postModel?.data.numberOfCommentsString() {
            cell.numberOfCommentsLabel.text = numberOfCommentsString
        }
        
        cell.thumbnailView.image = UIImage()
        if let thumbnailURLString = postModel?.data.thumbnail?.absoluteString {
            cell.thumbnailView.downloadImage(with: thumbnailURLString)
        }
        
        return cell
    }
}

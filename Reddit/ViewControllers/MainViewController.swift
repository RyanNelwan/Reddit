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
    var restoredOffset: CGPoint = .zero
    
    lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.tableView.addSubview(r)
        return r
    }()
    
    var isRequesting: Bool = false {
        didSet {
            if !isRequesting && self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    var isRestoring: Bool = false {
        didSet {
            if isRestoring && self.isRequesting {
                self.dataTask?.cancel()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.fetchTopPosts()
    }
    
    @IBAction func fetchMore() {
        self.fetchTopPosts()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do a complete refresh. Clear out old data.
        self.requestManager = RequestManager()
        self.redditModel = nil
        self.fetchTopPosts()
    }
    
    func fetchTopPosts() {
        let urlString = self.requestManager.urlString()
        
        self.dataTask?.cancel()
        self.isRequesting = true
        
        if let components = URLComponents(string: urlString) {
            guard let url = components.url else { return }
            self.dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                dispatchMain { self.isRequesting = false }
                
                // Check if we're restoring
                if self.isRestoring {
                    return
                }
                
                if error != nil {
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
            
            dispatchMain { self.tableView.reloadData() }
        } catch {
            dispatchMain { self.presentAlert(with: "Sorry, there was an error with fetching the top reddit posts. Please try again.") }
        }
    }
    
    func presentAlert(with errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

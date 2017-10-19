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
    var restoredOffset: CGPoint = .zero
    
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

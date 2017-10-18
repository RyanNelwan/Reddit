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
    var dataTask: URLSessionDataTask?
    
    // Temp Fixtures
    let data = ["Some data", "Another data value", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras eu tristique urna. Praesent faucibus ligula quis turpis vehicula mattis. Curabitur odio lectus, dapibus quis auctor et, imperdiet a eros. Proin gravida sit amet sapien et accumsan. Nullam sit amet mauris nunc. Donec consectetur justo mauris, quis viverra mi sodales quis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec non nibh et diam suscipit accumsan a nec lorem. Nulla id interdum libero, sed dapibus ex."]
    
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
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTopPosts() {
        let urlString = "https://www.reddit.com/top.json"
        
        self.dataTask?.cancel()
        if let components = URLComponents(string: urlString) {
            guard let url = components.url else { return }
            
            self.dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Error")
                }
                
                guard let data = data else { return }
                self.handleDataResponse(with: data)
            }
        }
        
        self.dataTask?.resume()
    }
    
    func handleDataResponse(with data: Data) {
        // https://developer.apple.com/swift/blog/?id=37
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(json)
        } catch {
            print("Error")
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostTableViewCell
        cell.titleLabel.text = self.data[indexPath.row]
        return cell
    }
}

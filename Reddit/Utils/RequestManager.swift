//
//  RequestManager.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import Foundation

struct RequestManager: Codable {
    let baseURLString = "https://www.reddit.com"
    let path = "/top"
    let format = "json"
    let limit = 10
    var nextID: String?
    
    func urlString() -> String {
        var s = "\(baseURLString)\(path).\(format)?limit=\(limit)"
        if nextID != nil {
            s += "&after=\(self.nextID!)"
        }
        return s
    }
}

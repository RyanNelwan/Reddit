//
//  RequestManager.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import Foundation

struct RequestManager {
    let baseURLString = "https://www.reddit.com"
    let path = "/top"
    let format = "json"
    let limit = 10
    
    func urlString() -> String {
        return "\(baseURLString)\(path).\(format)?limit=\(limit)"
    }
}

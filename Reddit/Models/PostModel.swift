//
//  PostModel.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import Foundation

/*
 {
     "kind":"Listing",
     "data":{
         "modhash":"",
         "whitelist_status":"all_ads",
         "children":[
             {
                 "kind":"t3",
                 "data":{ ... }
             }
         ]
     }
 }
 */

struct PostModel: Codable {
    struct Data: Codable {
        let title: String?
        let author:String?
        let thumbnail: URL?
        let num_comments: Int
        let created: Double
        
        func numberOfCommentsString()-> String {
            return "\(self.num_comments) \(self.num_comments == 0 || self.num_comments > 1 ? "comments" : "comment")"
        }
        
        func dateString()-> String {
            return "\(created)"
        }
        
        func log() {
            print("""
                ----------------------------------------------------------------------
                - PostModel.data -
                Post Title: \(String(describing: self.title))
                Post Author: \(String(describing: self.author))
                Post thumbnail: \(String(describing: self.thumbnail))
                Post num_comments: \(self.num_comments)
                Post created: \(self.created)
                ----------------------------------------------------------------------
                """)
        }
    }
    let kind: String?
    let data: Data
}


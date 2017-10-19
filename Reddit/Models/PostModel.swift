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
     "kind":"t3",
     "data":{ ... }
 }
*/

struct PostModel: Codable {
    
    struct Data: Codable {
        
        let title: String?
        let author:String?
        let thumbnail: URL?
        let num_comments: Int
        let created: Double
        let created_utc: Double
        let preview: PreviewModel?
        
        func numberOfCommentsString()-> String {
            return "\(self.num_comments) \(self.num_comments == 0 || self.num_comments > 1 ? "comments" : "comment")"
        }
        
        func dateString()-> String {
            let date = Date(timeIntervalSince1970: created_utc)
            let diff: TimeInterval = -date.timeIntervalSinceNow
            var string: String = ""
            
            // print("created: \(created_utc) | timeDiff: \(diff)")
            
            if diff < 60 {
                string = "Just now"
            } else if diff/60 < 60 {
                let m = String(format: "%.f", diff/60)
                string = "\(m) minutes ago"
            } else if diff/(60*60) < 24 {
                let h = String(format: "%.f", diff/(60*60))
                string = "\(h) hours ago"
            }
            
            return string
        }
        
        func containsImage()-> Bool {
            if self.preview?.images != nil && !(self.preview?.images?.isEmpty)! {
                return true
            }
            return false
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
                Post thumbnail: \(String(describing: self.thumbnail))
                Post Image URL: \(String(describing: self.containsImage() ? String(describing: self.preview?.images![0].source?.url) : nil ))
                ----------------------------------------------------------------------
                """)
        }
    }
    
    let kind: String?
    let data: Data
}


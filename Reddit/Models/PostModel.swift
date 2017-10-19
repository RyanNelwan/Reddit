//
//  PostModel.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import UIKit

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
        let url: URL?
        let is_self: Bool
        
        func numberOfCommentsString()-> String {
            return "\(self.num_comments) \(self.num_comments == 0 || self.num_comments > 1 ? "comments" : "comment")"
        }
        
        func dateString()-> String {
            let date = Date(timeIntervalSince1970: created_utc)
            let diff: TimeInterval = -date.timeIntervalSinceNow
            var string: String = ""
            
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
            // Check if it's a gif
            if let sourceURLString = self.url?.absoluteString {
                if sourceURLString.lowercased().range(of:"gif") != nil {
                    return false
                }
            }
            // Ensure images array is not nill and is not empty
            if self.preview?.images != nil && !(self.preview?.images?.isEmpty)! {
                return true
            }
            return false
        }
        
        func containsThumbnail()-> Bool {
            return self.thumbnail != nil
                && self.thumbnail?.absoluteString.range(of: "default") == nil
                && self.thumbnail?.absoluteString.range(of: "self") == nil
        }
        
        func isSelf()-> Bool {
            return self.is_self
        }
    }
    
    let kind: String? // Every "kind" is "t3"
    let data: Data
}

extension PostModel {
    func log() {
        print("""
            ----------------------------------------------------------------------
            - PostModel.data -
            Post Title: \(String(describing: self.data.title))
            Post Author: \(String(describing: self.data.author))
            Post num_comments: \(self.data.num_comments)
            Post created: \(self.data.created)
            Post thumbnail: \(String(describing: self.data.thumbnail)) | \(self.data.containsThumbnail())
            Post Image URL: \(String(describing: self.data.containsImage() ? String(describing: self.data.preview?.images![0].source?.url) : nil ))
            Post is_self: \(self.data.is_self)
            Post sourceURL: \(String(describing: self.data.url?.absoluteString))
            ----------------------------------------------------------------------
            """)
    }
}

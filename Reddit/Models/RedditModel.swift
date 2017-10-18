//
//  RedditModel.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

// Helpful Links:
// https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types

import Foundation

struct RedditModel: Codable {
    struct Data: Codable {
        let children: [PostModel]
        let after: String?
    }
    
    func log() {
        print("""
            Root After: \(String(describing: self.data.after))
            Post Title: \(String(describing: self.data.children[0].data.title))
            Post Kind: \(String(describing: self.data.children[0].kind))
            """)
    }
    
    let kind: String?
    let data: Data
}

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
        
        // https://www.reddit.com/dev/api/
        // As per reddit api documentation, the concept of numerical pages does not exists.
        //
        // "Listings do not use page numbers because their content changes so frequently.
        // Instead, they allow you to view slices of the underlying data. Listing JSON
        // responses contain after and before fields which are equivalent to the "next"
        // and "prev" buttons on the site and in combination with count can be used to page
        // through the listing."
        let after: String?
    }
    
    func log() {
        print("""
            ----------------------------------------------------------------------
            - RedditModel -
            Root After: \(String(describing: self.data.after))
            Number of posts: \(self.data.children.count)
            ----------------------------------------------------------------------
            """)
    }
    
    let kind: String?
    let data: Data
}

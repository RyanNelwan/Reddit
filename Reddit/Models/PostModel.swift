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
    }
    let kind: String?
    let data: Data
}


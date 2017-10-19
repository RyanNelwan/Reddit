//
//  PreviewModel.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import Foundation

/*
 "preview":{
     "images":[
         {
         "source":{
                 "url":"URL",
                 "width":2048,
                 "height":2048
             },
             "resolutions":[
                 {
                 "url":"URL",
                 "width":108,
                 "height":108
                 }
             ],
             "variants":{
                 ...
             },
             "id":"..."
         }
     ],
     "enabled":true
 }
*/

struct PreviewModel: Codable {
    struct ImageModel: Codable {
        struct Source: Codable {
            let url: URL?
        }
        let source: Source?
    }
    let images: [ImageModel]?
}

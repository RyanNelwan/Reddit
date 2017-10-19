//
//  UIImageView+Reddit.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import UIKit

extension UIImageView {

    // Asynchronous image download
    public func downloadImage(with string: String, completion: (() -> Void)!, failure: ((_ error: Error) -> Void)!) {
        URLSession.shared.dataTask(with: NSURL(string: string)! as URL, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if error != nil {
                    if failure != nil {
                        failure(error!)
                    }
                    return
                }
                
                let image = UIImage(data: data!)
                self.image = image
                
                if completion != nil {
                    completion()
                }
            })
        }).resume()
    }
}

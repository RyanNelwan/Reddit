//
//  Helpers.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/19/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import Foundation

func dispatchMain(closure:@escaping () ->()) {
    DispatchQueue.main.async(execute: closure)
}

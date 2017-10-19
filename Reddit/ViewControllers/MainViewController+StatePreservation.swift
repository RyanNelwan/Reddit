//
//  MainViewController+StatePreservation.swift
//  Reddit
//
//  Created by Ryan Nelwan on 10/18/17.
//  Copyright © 2017 Ryan Nelwan. All rights reserved.
//

import UIKit

extension MainViewController {
    
    override func encodeRestorableState(with coder: NSCoder) {
        // Encode model
        if let redditModel = self.redditModel {
            let encoder = JSONEncoder()
            let encodedModel = try! encoder.encode(redditModel)
            coder.encode(encodedModel, forKey: "RedditModel")
            coder.encode(self.tableView.contentOffset, forKey: "TableViewOffset")
        }
        super.encodeRestorableState(with: coder)
    }
    
    func setTimeout(_ delay:TimeInterval, block:@escaping ()->Void) -> Timer {
        return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let restoredRedditData = coder.decodeObject(forKey: "RedditModel") as? Data {
            do {
                // Restore our model
                let redditModel = try JSONDecoder().decode(RedditModel.self, from: restoredRedditData)
                
                self.redditModel = redditModel
                self.isRestoring = true
                
                if self.isRequesting {
                    self.dataTask?.cancel()
                }
                
                // Restore our nextID for request manager
                if let nextID = redditModel.data.after {
                    self.requestManager.nextID = nextID
                }
                
                // Restore our tableview offset
                self.restoredOffset = coder.decodeCGPoint(forKey: "TableViewOffset")
                
            } catch {
                print("Could not restore previous state")
            }
        }
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        
        self.tableView.reloadData()
        self.tableView.setContentOffset(self.restoredOffset, animated: false)
        
        if self.isRestoring {
            self.isRequesting = false
        }
        
        self.isRestoring = false
        super.applicationFinishedRestoringState()
    }
}

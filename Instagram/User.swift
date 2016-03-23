//
//  User.swift
//  Instagram
//
//  Created by Daniel on 3/21/16.
//  Copyright © 2016 Notabela. All rights reserved.
//

import UIKit
import Parse

class User: PFUser
{
    class func fetchPosts(sucess: ([PFObject]?) -> (), failure: (NSError?) -> () )
    {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("updated_at")
        query.includeKey("author")
        query.limit = 20
    
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts
            {
                sucess(posts)
            }
            else
            {
                failure(error)
            }
        }
    }
    
    class func fetchMyPosts(sucess: ([PFObject]?) -> (), failure: (NSError?) -> () )
    {
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        query.includeKey("updated_at")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts
            {
                sucess(posts)
            }
            else
            {
                failure(error)
            }
        }
    }

    
}

//
//  postCell.swift
//  Instagram
//
//  Created by Daniel on 3/22/16.
//  Copyright © 2016 Notabela. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class postCell: UITableViewCell
{
    
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var postCaption: UILabel!
    
    var post: PFObject!
    {
        didSet
        {
            self.postImageView.file = post["media"] as? PFFile
            self.postImageView.loadInBackground()
            postCaption.text = post["caption"] as? String
        }
    }
    
}

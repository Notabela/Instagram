//
//  HomeViewController.swift
//  Instagram
//
//  Created by Daniel on 3/21/16.
//  Copyright © 2016 Notabela. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController
{
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onLogout(sender: AnyObject)
    {
        ParseClient.logout()
    }

}
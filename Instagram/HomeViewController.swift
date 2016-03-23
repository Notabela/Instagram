//
//  HomeViewController.swift
//  Instagram
//
//  Created by Daniel on 3/21/16.
//  Copyright © 2016 Notabela. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    var posts: [PFObject]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        fetchPosts()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        fetchPosts()
    }
    
    private func fetchPosts()
    {
        User.fetchPosts({ (object: [PFObject]?) -> () in
            
            self.posts = object
            self.tableView.reloadData()
            
            }) { (error: NSError?) -> () in
                
            print("Unable to retrieve data")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! postCell
        cell.post = posts![indexPath.section]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if posts != nil
        {
            return (posts?.count)!
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = PFImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        // Use the section number to get the right URL
        let post = posts![section]
        let author = post["author"] as! PFUser
        
        if let image = author.objectForKey("profileImage")
        {
            profileView.file = image as? PFFile
            profileView.loadInBackground()
        }
        else
        {
            profileView.image = UIImage(named: "avatar.png")
        }
        
        headerView.addSubview(profileView)
        
        // Add a UILabel for the username here
        let userLabel = UILabel(frame: CGRect(x:50, y: 10, width: 200, height: 30))
        userLabel.text = author.username
        headerView.addSubview(userLabel)
        
        //Add a UIlabel for the time created
        let timeLabel = UILabel()
        let timestampString = post["timeStamp"] as! String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
        let timestamp = formatter.dateFromString(timestampString)
        timeLabel.text = NSDate().offsetFrom(timestamp!)
        timeLabel.textColor = UIColor.grayColor()
        headerView.addSubview(timeLabel)
        
        //Set proper constraints for timeLabel
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        let rightConstraint = timeLabel.rightAnchor.constraintEqualToAnchor(headerView.rightAnchor, constant: -8)
        let bottomConstraint = timeLabel.bottomAnchor.constraintEqualToAnchor(headerView.bottomAnchor)
        let topConstraint = timeLabel.topAnchor.constraintEqualToAnchor(headerView.topAnchor)
        NSLayoutConstraint.activateConstraints([bottomConstraint,rightConstraint, topConstraint])
        view.layoutIfNeeded()
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @IBAction func onLogout(sender: AnyObject)
    {
        ParseClient.logout()
    }

}

//extend NSDate to handle mins ago and years ago etc
extension NSDate
{
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let default_date = formatter.stringFromDate(date)
        
        if yearsFrom(date)   > 0 { return default_date   }
        if monthsFrom(date)  > 0 { return default_date   }
        if weeksFrom(date)   > 0 { return default_date   }
        if daysFrom(date)    > 0 { return default_date   }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

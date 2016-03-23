//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Daniel on 3/21/16.
//  Copyright © 2016 Notabela. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var backgroundImage: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var phototype: String?
    var posts: [PFObject]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //make profile Image round
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        
        usernameLabel.text = (PFUser.currentUser()?.username)!
        
        print(PFUser.currentUser()?.objectForKey("profileImage"))
        if let image = PFUser.currentUser()?.objectForKey("profileImage")
        {
            self.profileImage.file = image as? PFFile
            self.profileImage.loadInBackground()
        }
        
        if let image = PFUser.currentUser()?.objectForKey("backgroundImage")
        {
            self.backgroundImage.file = image as? PFFile
            self.backgroundImage.loadInBackground()
        }
        
        //setup table
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        fetchPosts()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell") as! postCell
        cell.post = posts![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts != nil
        {
            return (posts?.count)!
        }
        else
        {
            return 0
        }
    }
    
    private func fetchPosts()
    {
        User.fetchMyPosts({ (success:[PFObject]?) -> () in
            self.posts = success
            self.tableView.reloadData()
            }) { (error: NSError?) -> () in
            print(error?.localizedDescription)
        }
    }
    
    private func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    private func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func onSettings(sender: AnyObject)
    {
        let actionSheet = UIAlertController(title: "Settings", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Profile Picture", style: .Default, handler: { action in
            self.newPhoto()
            self.phototype = "Profile Picture"
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Background Picture", style: .Default, handler: { action in
            self.newPhoto()
            self.phototype = "Background Picture"
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func newPhoto()
    {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        
        //this returns an optional that we must cast to a UIImage
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            if phototype! == "Profile Picture"
            {
                let resized_image = resize(image, newSize: CGSize(width: 200, height: 200))
                profileImage.image = resized_image
                let _image = self.getPFFileFromImage(resized_image)
                PFUser.currentUser()?.setObject(_image!, forKey: "profileImage")
                
            }
            else if phototype! == "Background Picture"
            {
                let resized_image = resize(image, newSize: CGSize(width: 1000, height: 1000))
                backgroundImage.image = resized_image
                let _image = self.getPFFileFromImage(resized_image)
                PFUser.currentUser()?.setObject(_image!, forKey: "backgroundImage")
            }
            PFUser.currentUser()?.saveInBackground()
        }
    }
    
    @IBAction func onLogout(sender: AnyObject)
    {
        ParseClient.logout()
    }
    
}

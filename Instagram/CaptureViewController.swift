//
//  CaptureViewController.swift
//  Instagram
//
//  Created by Daniel on 3/21/16.
//  Copyright © 2016 Notabela. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var captureView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        reset()
    }
    
    private func reset()
    {
        captionField.text = ""
        captionField.enabled = false
        submitButton.enabled = false
        captureView.image = nil
        choosePhotoButton.enabled = true
        choosePhotoButton.alpha = 1
    }
    
    private func showAlert(title: String, message: String)
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel) {_ in /*Some Code to Execute*/}
        alertView.addAction(action)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func onLogout(sender: AnyObject)
    {
        ParseClient.logout()
    }
    
    @IBAction func onChoosePhoto(sender: AnyObject)
    {
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
        
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in showCamera() }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in showAlbum() }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            captureView.image = image
            captionField.enabled = true
            submitButton.enabled = true
            choosePhotoButton.enabled = false
            choosePhotoButton.alpha = 0
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
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
    
    @IBAction func onSubmit(sender: AnyObject)
    {
        let progressBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressBar.opacity = 0
        
        let resized_image = self.resize(captureView.image!, newSize: CGSize(width: 400, height: 400))
        
        Post.postUserImage(resized_image, withCaption: captionField.text) { (success: Bool, error: NSError?) -> Void in
            
            if success
            {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.showAlert("Success", message: "Image Posted")
                self.reset()
            }
            else
            {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.showAlert("Error", message: (error?.localizedDescription)!)
            }
        }
    }
    
}

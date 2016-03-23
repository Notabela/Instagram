//
//  LoginViewController.swift
//  Instagram
//
//  Created by Daniel on 3/20/16.
//  Copyright © 2016 Notabela. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class LoginViewController: UIViewController
{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    private func showAlert(title: String, message: String)
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel) {_ in /*Some Code to Execute*/}
        alertView.addAction(action)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func onSignIn(sender: AnyObject)
    {
        let progressBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressBar.opacity = 0
        
        ParseClient.login((usernameField.text!, password: passwordField.text!), success: { (user: PFUser?) -> () in
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.performSegueWithIdentifier("loginSegue", sender: self)
            
            }) { (error: NSError?) -> () in
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.showAlert("Error", message: (error?.localizedDescription)!)

            }
    }
    
    @IBAction func onSignUp(sender: AnyObject)
    {
        if usernameField.text! == ""
        {
            self.showAlert("Error", message: "Username is required")
            return
        }
        else if passwordField.text! == ""
        {
            self.showAlert("Error", message: "Password is required")
            return
        }
        
        let progressBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressBar.opacity = 0
        
        ParseClient.signUp((usernameField.text!, password: passwordField.text!), success: { (user: PFUser?) -> () in
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.performSegueWithIdentifier("loginSegue", sender: self)
            
            }) { (error: NSError?) -> () in
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.showAlert("Error", message: (error?.localizedDescription)!)
        }
        
        
    }
}

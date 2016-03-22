//
//  LoginViewController.swift
//  Instagram
//
//  Created by Daniel on 3/20/16.
//  Copyright © 2016 Notabela. All rights reserved.
//

import UIKit
import Parse

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
        
        ParseClient.login((usernameField.text!, password: passwordField.text!), success: { (user: PFUser?) -> () in
            
            self.performSegueWithIdentifier("loginSegue", sender: self)
            
            }) { (error: NSError?) -> () in
                
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
        
        ParseClient.signUp((usernameField.text!, password: passwordField.text!), success: { (user: PFUser?) -> () in
            
            self.performSegueWithIdentifier("loginSegue", sender: self)
            
            }) { (error: NSError?) -> () in
                
            self.showAlert("Error", message: (error?.localizedDescription)!)
        }
        
        
    }
}

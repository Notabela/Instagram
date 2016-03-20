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
    
    @IBAction func onSignIn(sender: AnyObject)
    {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil
            {
                print("logged in")
            }
        }
    }
    
    
    @IBAction func onSignUp(sender: AnyObject)
    {
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success
            {
                print("Created a user")
            }
            else
            {
                print(error?.localizedDescription)
            }
        }
    }
}

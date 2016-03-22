//
//  ParseClient.swift
//  Instagram
//
//  Created by Daniel on 3/21/16.
//  Copyright © 2016 Notabela. All rights reserved.
//

import UIKit
import Parse

class ParseClient: Parse
{
    
    class func Authenticate()
    {
       ParseClient.initializeWithConfiguration(ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
            configuration.applicationId = "com.notabela.belagram"
            configuration.clientKey = "Parker@18***"
            configuration.server = "https://belagram.herokuapp.com/parse"
        }))
    }
    
    class func login(parameters: (username: String, password: String), success: (PFUser?) -> (), failure: (NSError?) -> () )
    {
        PFUser.logInWithUsernameInBackground(parameters.username, password: parameters.password) { (user: PFUser?, error: NSError?) -> Void in
            
            if let user = user
            {
                success(user)
            }
            else
            {
                failure(error)
            }
        }
    }
    
    class func signUp(parameters: (username: String, password: String), success: (PFUser?) -> (), failure: (NSError?) -> () )
    {
        let newUser = PFUser()
        
        newUser.username = parameters.username
        newUser.password = parameters.password
        
        newUser.signUpInBackgroundWithBlock { (signedUp: Bool, error: NSError?) -> Void in
            
            if signedUp
            {
                success(newUser)
            }
            else
            {
                failure(error)
            }
        }
    }
    
    class func logout()
    {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName("didLogOut", object: nil)
    }
}



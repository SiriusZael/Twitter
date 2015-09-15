//
//  ViewController.swift
//  Twitter
//
//  Created by Matt Rucker on 9/9/15.
//  Copyright (c) 2015 tumblr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) -> () in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                println(error)
            }
        }
    }
}


//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Matt Rucker on 9/14/15.
//  Copyright (c) 2015 tumblr. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    @IBOutlet weak var tweetBodyView: UITextView!
    
    var reply: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetBodyView.text = reply ?? ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.postTweetWithParams(["status": tweetBodyView.text], completion: { (tweet, error) -> () in
            if error != nil {
                println(error)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

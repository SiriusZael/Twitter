//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Matt Rucker on 9/9/15.
//  Copyright (c) 2015 tumblr. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    var replyingCell: TweetCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "onLoad", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.addSubview(self.refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
    }
    
    override func viewDidAppear(animated: Bool) {
        onLoad()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        let tweet = tweets![indexPath.row]
        
        cell.tweet = tweet
        cell.delegate = self
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func onLoad() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) ->() in
            self.refreshControl.endRefreshing()
            if (error != nil) {
                println(error)
            } else {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        })
    }

    func tweetCell(tweetCell: TweetCell) {
        replyingCell = tweetCell
        self.performSegueWithIdentifier("composeSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tweetDetailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            
            let tweet = tweets![indexPath.row]
            
            let tweetDetailController = segue.destinationViewController as! TweetDetailViewController
            tweetDetailController.tweet = tweet
        } else if segue.identifier == "composeSegue" {
            if let replyingCell = replyingCell {
                let indexPath = tableView.indexPathForCell(replyingCell)!
                
                let tweet = tweets![indexPath.row]
                let navigationController = segue.destinationViewController as! UINavigationController
                let composeTweetController = navigationController.topViewController as! ComposeTweetViewController
                
                composeTweetController.reply = "@\(tweet.user!.screenname!)"
            }
        }
    }
    

}

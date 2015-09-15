//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Matt Rucker on 9/14/15.
//  Copyright (c) 2015 tumblr. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweet: Tweet!
    
    func afterFavorite(tweet: Tweet?, error: NSError?) -> () {
        if error != nil {
            println(error)
        } else {
            self.tweet = tweet
            self.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    func reloadData() {
        userNameLabel.text = tweet.user?.screenname
        tweetTextLabel.text = tweet.text
        timestampLabel.text = tweet.createdAtString
        profileImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!)!)
        favoriteIcon.hidden = !tweet.favorited!
        
        if tweet.favorited! {
            favoriteButton.setTitle("Unfavorite", forState: .Normal)
        } else {
            favoriteButton.setTitle("Favorite", forState: .Normal)
        }
        
        retweetButton.enabled = !tweet.retweeted!
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d HH:mm:ss y";
        timestampLabel.text = formatter.stringFromDate(tweet.createdAt!)
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if tweet.favorited! {
            TwitterClient.sharedInstance.unfavoriteTweet(tweet.id, completion: afterFavorite)
        } else {
            TwitterClient.sharedInstance.favoriteTweet(tweet.id, completion: afterFavorite)
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet.id, completion: { (tweet, error) ->() in
            if error != nil {
                println(error)
            } else {
                self.navigationController!.popViewControllerAnimated(true)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let composeTweetController = navigationController.topViewController as! ComposeTweetViewController
        
        composeTweetController.reply = "@\(tweet.user!.screenname!)"
    }

}

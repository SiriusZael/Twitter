//
//  TweetCell.swift
//  Twitter
//
//  Created by Matt Rucker on 9/14/15.
//  Copyright (c) 2015 tumblr. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    optional func tweetCell(tweetCell: TweetCell)
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            userNameLabel.text = tweet.user?.screenname
            tweetTextLabel.text = tweet.text
            profileImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!)!)
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d HH:mm:ss y";
            timestampLabel.text = formatter.stringFromDate(tweet.createdAt!)
            retweetCountLabel.text = "RT: \(tweet.retweetCount ?? 0)"
            retweetButton.enabled = !tweet.retweeted!
            
            if tweet.favorited! {
                favoriteButton.setTitle("Unfavorite", forState: .Normal)
            } else {
                favoriteButton.setTitle("Favorite", forState: .Normal)
            }
        }
    }
    
    var indexPath: NSIndexPath!
    
    func afterFavorite(tweet: Tweet?, error: NSError?) -> () {
        if error != nil {
            println(error)
        } else {
            self.tweet = tweet
            self.reload()
        }
    }
    
    func reload() {
        retweetCountLabel.text = "RT: \(tweet?.retweetCount ?? 0)"
        
        if tweet.favorited! {
            favoriteButton.setTitle("Unfavorite", forState: .Normal)
        } else {
            favoriteButton.setTitle("Favorite", forState: .Normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
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
                self.tweet.retweetCount = tweet!.retweetCount
                self.tweet.retweeted = tweet!.retweeted
                self.reload()
            }
        })
    }
    
    @IBAction func onReply(sender: AnyObject) {
        delegate?.tweetCell?(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

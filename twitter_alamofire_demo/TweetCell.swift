//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Felipe De La Torre on 11/23/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var profileNameText: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var tweetTextLabel: UILabel!
    var tweet : Tweet?
    var user : User?
    var indexPath : IndexPath?
    var parentView : TimelineViewController?
    
    
    func content (){
         if let tweet = self.tweet, let user = self.user {
            if let profilePictureURL = user.profilepic {
                profileImageView.af_setImage(withURL: profilePictureURL)
            }
            tweetTextLabel.text = tweet.text
            profileNameText.text = user.name
            self.updateFavoriteCount(tweet)
            self.updateFavoriteIcon(tweet)
            usernameText.text = "@\(user.screenName!)"
        }
    }
    
    // changes the icon for favorite and retweet
    func updateFavoriteIcon(_ tweet: Tweet) {
        if (tweet.favorited! == true) {
            self.favoriteButton.setImage(UIImage(named: "favor-icon-red.png"), for: .normal)
        }
        else {
            self.favoriteButton.setImage(UIImage(named: "favor-icon.png"), for: .normal)
        }
        if (tweet.retweeted == true) {
            self.retweetButton.setImage(UIImage(named: "retweet-icon-green.png"), for: .normal)
        }
        else {
            self.retweetButton.setImage(UIImage(named: "retweet-icon.png"), for: .normal)
        }
    }
    
    // updates the favorite count
    func updateFavoriteCount(_ tweet: Tweet) {
        favoriteButton.setTitle("\(tweet.favoriteCount!)", for: .normal)
        retweetButton.setTitle("\(tweet.retweetCount)", for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onTapRetweet(_ sender: Any) {
        if (tweet!.retweeted == false) {
            APIManager.shared.retweet(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error Favoriting Tweet: \(error.localizedDescription)")
                } else {
                    self.parentView?.completeNetworkRequest()
                }
            }
        }
        else {
            APIManager.shared.unretweet(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error Favoriting Tweet: \(error.localizedDescription)")
                } else {
                    self.parentView?.completeNetworkRequest()
                }
            }
        }
        
    }
    
    @IBAction func onTapFavorite(_ sender: Any) {
        if (tweet!.favorited == false) {
        APIManager.shared.favorite(tweet!) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully favorited the following Tweet: \n\(tweet.text)")
                self.parentView?.completeNetworkRequest()
            }
        }
        
    }
        else {
            APIManager.shared.unfavorite(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error Favoriting Tweet: \(error.localizedDescription)")
                } else {
                    self.parentView?.completeNetworkRequest()
                }
            }
        }
        
    
    }
}

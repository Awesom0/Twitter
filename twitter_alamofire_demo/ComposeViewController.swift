//
//  ComposeTableViewController.swift
//  twitter_alamofire_demo
//
//  Created by Felipe De La Torre on 11/23/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController{
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    var user : User?
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onCancel(_ sender: Any) {
        performSegue(withIdentifier: "backHomeSegue", sender: nil)
        
    }
    
    
    func userInformation() {
        if let user = user {
            profileNameLabel.text = user.name
            usernameLabel.text = "@\(user.screenName!)"
            if let propicURL = user.profilepic {
                profilePictureImage.af_setImage(withURL: propicURL)
            }
            
        }
    }
    
    
    @IBAction func onTweet(_ sender: Any) {
        let tweetText = tweetTextView.text!
        APIManager.shared.composeTweet(with: tweetText) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print ("success")
            }
        }
        performSegue(withIdentifier: "backHomeSegue", sender: nil)

    }
    
    
}

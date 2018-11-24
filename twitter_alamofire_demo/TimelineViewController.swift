//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-08-11.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var homeTableView: UITableView!
    var tweets : [Tweet] = []
    var refreshControl: UIRefreshControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUserInfo()
        homeTableView.dataSource = self
        homeTableView.rowHeight = UITableView.automaticDimension
        homeTableView.estimatedRowHeight = 200
        
        
        // pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.completeNetworkRequest), for: .valueChanged)
        homeTableView.insertSubview(refreshControl, at: 0)
        
        self.completeNetworkRequest()
    }

    
    func updateUserInfo() {
        APIManager.shared.getCurrentAccount { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let user = user {
                User.current = user
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func completeNetworkRequest() {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self.tweets = tweets!
                self.homeTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    // Start of Action for buttons
    
    // when compose is tapped
    @IBAction func onCompose(_ sender: Any){
        performSegue(withIdentifier: "composeSegue", sender: nil)
    
    }
    // when logout is tapped
    @IBAction func onLogout(_ sender: Any) {
         APIManager.shared.logout()
        performSegue(withIdentifier: "relogSegue", sender: nil)

    }
    // end of Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.updateUserInfo()
        if (segue.identifier == "composeSegue") {
            if let composeView = segue.destination as? ComposeViewController {
                composeView.user = User.current
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.user = tweet.user
        cell.indexPath = indexPath
        cell.content()
        cell.parentView = self as TimelineViewController
        return cell
    }
}


 //
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Betsy Avila on 9/18/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]() //var is mutable, let is not, make a dictß
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        
        //to reload tweets, it's set to self because it stays on the same screen
        //#selector needs a function, use fix to add @objc
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl //connect storyboard to coded variable
    }
    
    @objc func loadTweet(){ //called from viewLoad to see changes
        //gets triggered at loading time and the second time when user pulls to refresh
        numberOfTweets = 20
        
        //get hometimeline link from API documentation
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        //set existing parameters, number of tweets must be dynamic
        let myParams = ["count": numberOfTweets]
        
        
        //call API
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: {(tweets:[NSDictionary]) in
            
            self.tweetArray.removeAll() //empties entire array
            
            for tweet in tweets {//populate page with tweets
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData() //refresh and reload new data
            
            self.myRefreshControl.endRefreshing()//stop the page once done reloading
            
        }, failure: { (Error) in
            print("Could not retrieve tweets! oh no!")
        })
    }
    
    func loadMoreTweets(){//called anytime user gets close to the end of the table
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json" //use same API call from loadTweet()
        numberOfTweets = numberOfTweets + 20 //add more tweets onto the variable by 20
        
        //repeat steps from loadTweet()
        let myParams = ["count": numberOfTweets]
        //call API
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: {(tweets:[NSDictionary]) in
            
            self.tweetArray.removeAll() //empties entire array
            
            for tweet in tweets {//populate page with tweets
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData() //refresh and reload new data
            
        }, failure: { (Error) in
            print("Could not retrieve tweets! oh no!")
        })
        
    }
    
    @IBAction func onLogout(_ sender: Any) { //logout button, switched to action button
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil) //reflect logout on the app
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //connect cells from the storyboard for profiles
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        //extract user's name referencing API. Must access through a dictionary
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String//text is a key from the API
        
        //extract user pfp
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!) //key from API
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData) //set Image to reflect on storyboard
        }
        
        return cell
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //only one section
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count //displays what number of tweets we get from API
    }

   
}

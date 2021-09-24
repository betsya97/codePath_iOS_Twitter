//
//  TweetViewController.swift
//  Twitter
//
//  Created by Betsy Avila on 9/21/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    @IBOutlet weak var tweetTextView: UITextView! //text view
    
    @IBAction func tweet(_ sender: Any) { //tweetcall
        if(!tweetTextView.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success:{ self.dismiss(animated: true, completion: nil)}, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //dismiss controller to cancel
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

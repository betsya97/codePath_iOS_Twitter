//
//  loginViewController.swift
//  Twitter
//
//  Created by Betsy Avila on 9/18/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLoginButton(_ sender: Any) {
        let myUrl = "https://api.twitter.com/oauth/request_token"//url from API
        TwitterAPICaller.client?.login(url: myUrl, success: {
            
            //don't ask to login a second time
            UserDefaults.standard.set(true, forKey: "userloggedIn")
            
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { Error in
            print("Could not login")
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //once the page shows up check the users default to a specific key
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true{
            self.performSegue(withIdentifier: "logInToHome", sender: self)
        }
    }
    

}

//
//  WelcomeViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 21/07/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth
import SVProgressHUD

class WelcomeViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var googleLoginView: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()
        
        //Set self as delegate and initiate views
        GIDSignIn.sharedInstance().uiDelegate = self
        googleLoginView.frame = CGRect(x: 13, y: view.frame.height - 60, width: view.frame.width - 26, height: 50)
        facebookLoginButton.frame = CGRect(x: 16, y: view.frame.height - 115 , width: view.frame.width - 32, height: 40)
        
        titleLabel.adjustsFontSizeToFitWidth = true
        subTitleLabel.adjustsFontSizeToFitWidth = true
        
        //Check to see if any user is Signed In
        if Auth.auth().currentUser != nil {
            
            // User is signed in.
            self.performSegue(withIdentifier: "goToMainTabBar", sender: self)
        } else {
            
            //facebookLoginButton may not exist IDK why
            if var delegate = facebookLoginButton {
                delegate.delegate = self
                facebookLoginButton.readPermissions = ["email"]
                
            }
        }
    }
    
    //MARK:- Add Facebook Login Functions Conforming to FBSDKLoginButtonDelegate
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            
            if let authenticationToken = FBSDKAccessToken.current() {
                print("Sucessfully logged into Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken.tokenString)
                Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
                    if let err = error {
                        print("Failed to create Firebase user with Facebook Account", err)
                        return
                    }
                    
                    print("Successfully logged into Firebase with Facebook", user?.user.email)
                    self.performSegue(withIdentifier: "goToMainTabBar", sender: self)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Sucessfully logged out of Facebook")
    }
}

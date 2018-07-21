//
//  RegisterViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 21/07/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            
            if error != nil {
                
                print(error)
                
            } else {
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
    }
}

//
//  OwnerLoginViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 01/08/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import FirebaseAuth

class OwnerLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "Some problem with sign in!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Try again?", style: .default) { (action) in
                    self.passwordTextField.text = ""
                    self.emailTextField.text = ""
                }
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToAddCarpet", sender: self)
                
            }
        }
    }
}

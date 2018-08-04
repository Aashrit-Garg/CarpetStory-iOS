//
//  AddCarpetViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 26/07/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddCarpetViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var breadthTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addCarpetPressed(_ sender: UIButton) {
        
        var ref: DocumentReference? = nil
        
        let data = [
            "name": nameTextField.text ?? "",
            "breadth": Int(breadthTextField.text!)!,
            "length": Int(lengthTextField.text!)!,
            "imageURL": imageTextField.text ?? "",
            "modelURL": modelTextField.text ?? "",
            "description": descriptionTextField.text ?? "",
            "category": categoryTextField.text ?? "",
            "mostViewed": true
            ] as [String : Any]
        
        ref = db.collection("Carpets").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    self.dismiss(animated: true, completion: nil)
                    print("Successfully Logout")
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }
        }
    }
}

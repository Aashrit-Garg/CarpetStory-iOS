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
import FirebaseAuth

class AddCarpetViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var breadthTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var tapView: UIView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapViewTapped))
        tapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapViewTapped() {
        
        nameTextField.endEditing(true)
        categoryTextField.endEditing(true)
        lengthTextField.endEditing(true)
        breadthTextField.endEditing(true)
        imageTextField.endEditing(true)
        modelTextField.endEditing(true)
        descriptionTextField.endEditing(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addCarpetPressed(_ sender: UIButton) {
        
        var ref: DocumentReference? = nil
        
        let data = [
            "name": nameTextField.text ?? "",
            "breadth": Int(breadthTextField.text!) ?? 0,
            "length": Int(lengthTextField.text!) ?? 0,
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
    
    @IBAction func logoutPressed(_ sender: UIButton) {
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

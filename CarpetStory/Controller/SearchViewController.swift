//
//  SearchViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 04/08/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SearchViewController: UIViewController {

    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var breadthTextField: UITextField!
    @IBOutlet weak var tapView: UIView!
    
    let db = Firestore.firestore()
    var condition : Int?
    var field : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapViewTapped))
        tapView.addGestureRecognizer(tapGesture)
    }

    @objc func tapViewTapped() {
        
        lengthTextField.endEditing(true)
        breadthTextField.endEditing(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func lengthSearchButtonPressed(_ sender: UIButton) {
        
        if Double(lengthTextField.text ?? "0")! > 0 {
            
            let double = Double(lengthTextField.text!)
            let doubleStr = String(format: "%.0f", double!)
            condition = Int(doubleStr)
            field = "length"
        }
        
        lengthTextField.endEditing(true)
        
        performSegue(withIdentifier: "goToCarpetTable", sender: self)
    }
    
    @IBAction func breadthSearchButtonPressed(_ sender: UIButton) {
        if Double(breadthTextField.text ?? "0")! > 0 {
            
            let double = Double(breadthTextField.text!)
            let doubleStr = String(format: "%.0f", double!)
            condition = Int(doubleStr)
            field = "breadth"
        }
        
        breadthTextField.endEditing(true)
        
        performSegue(withIdentifier: "goToCarpetTable", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CarpetTableViewController
        
        destinationVC.query = db.collection("Carpets").whereField(field!, isLessThanOrEqualTo: condition!)
    }
    
    
    
}

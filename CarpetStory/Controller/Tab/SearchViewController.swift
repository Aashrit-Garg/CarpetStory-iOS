//
//  SearchViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 04/08/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SVProgressHUD

class SearchViewController: UIViewController {

    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var breadthTextField: UITextField!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var searchLengthButton: UIButton!
    
    let db = Firestore.firestore()
    var conditionLength : Int?
    var conditionBreadth : Int?
    var field : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchLengthButton.layer.cornerRadius = 10
        SVProgressHUD.dismiss()

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
        
        if let doubleLength = Double(lengthTextField.text!), let doubleBreadth = Double(breadthTextField.text!) {
            
            let doubleStrL = String(format: "%.0f", doubleLength)
             let doubleStrB = String(format: "%.0f", doubleBreadth)
            conditionLength = Int(doubleStrL)
            conditionBreadth = Int(doubleStrB)
            
            lengthTextField.endEditing(true)
            breadthTextField.endEditing(true)
            
            performSegue(withIdentifier: "goToCarpetTable", sender: self)
        } else {
            let alert = UIAlertController(title: "Error!", message: "Size is either not entered or is invalid.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Retry?", style: .default) { (action) in
                self.lengthTextField.text = ""
                self.breadthTextField.text = ""
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CarpetTableViewController
        
        destinationVC.queryLength = db.collection("Carpets").whereField("length", isLessThanOrEqualTo: conditionLength!)
        destinationVC.queryBreadth = db.collection("Carpets").whereField("breadth", isLessThanOrEqualTo: conditionBreadth!)
        destinationVC.searchCalled = true
    }
}

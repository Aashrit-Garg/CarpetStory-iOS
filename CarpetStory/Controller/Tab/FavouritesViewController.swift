//
//  FavouritesViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 10/08/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SVProgressHUD

class FavouritesViewController: UIViewController {

    let db = Firestore.firestore()
    var docIDArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()
        
        let query = db.collection("Carpets").whereField("mostViewed", isEqualTo: true)
        
        query.addSnapshotListener { documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching document changes: \(error!)")
                return
            }
            
            for i in 0 ..< documents.count {
                let documentID = documents[i].documentID
                let query1 = self.db.collection("Carpets").document(documentID).collection("Favourites").whereField("wanted", isEqualTo: true)
                query1.addSnapshotListener { documentSnapshot, error in
                    guard let documents = documentSnapshot?.documents else {
                        print("Error fetching document changes: \(error!)")
                        return
                    }
                    
                    if documents.count != 0 {
                        
                        for i in 0 ..< documents.count {
                            
                            let documentID1 = documents[i].documentID
                            if documentID1 == Auth.auth().currentUser!.uid {
                                self.docIDArray.append(documentID)
                            }
                            
                        }
                        
                    } else {
                        
                        let alert = UIAlertController(title: "No carpets!", message: "Coudn't find carpets for mentioned size.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Go Back", style: .default) { (action) in
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                        
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            print(self.docIDArray)
        }
    }
    
    @IBAction func viewFavourites(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToCarpetTable", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FavouritesTableViewController
        
        destinationVC.documents = docIDArray
    }
    
}

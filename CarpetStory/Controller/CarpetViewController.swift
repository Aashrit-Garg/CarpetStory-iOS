//
//  CarpetViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 05/08/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import FirebaseFirestore
import FirebaseAuth

class CarpetViewController: UIViewController {

    @IBOutlet weak var carpetName: UILabel!
    @IBOutlet weak var carpetImage: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var breadth: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    
    let db = Firestore.firestore()
    var carpet : Carpet?
    var docID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()

        carpetName.text = carpet!.name
        category.text = carpet!.category
        length.text = "\(carpet!.length!)"
        breadth.text = "\(carpet!.breadth!)"
        descriptionTextView.text = carpet!.description
        SVProgressHUD.show()
        Alamofire.request(carpet!.imageURL!).responseImage { response in
            debugPrint(response)
            
            if let image = response.result.value {
                self.carpetImage.image = image
                SVProgressHUD.dismiss()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addToFavourites(_ sender: UIBarButtonItem) {
        
        let query = db.collection("Favourites").whereField("docID", isEqualTo: docID!).whereField("userID", isEqualTo: Auth.auth().currentUser!.uid)
        
        query.addSnapshotListener { documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching document changes: \(error!)")
                return
            }
            print(documents.count)
            if documents.count == 0 {
                var ref: DocumentReference? = nil
                let data = ["userID" : Auth.auth().currentUser?.uid, "docID" : self.docID!]
                ref = self.db.collection("Favourites").document(self.docID!)
                ref?.setData(data) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            } else {
                print("Item already exists in database.")
            }
        }
    }
}

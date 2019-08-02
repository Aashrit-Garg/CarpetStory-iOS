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

    // MARK: - Views initialised
    
    @IBOutlet weak var carpetName: UILabel!
    @IBOutlet weak var carpetImage: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var breadth: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    
    // MARK: - Global Variables Initialised
    
    // Database initialised.
    let db = Firestore.firestore()
    
    // Empty carpet object given value in previous view according to user selection.
    var carpet : Carpet?
    
    /**
     Empty document ID variable given value in previous view. Used to identify which carpet the user is currently
     on to help with adding the carpet to favourites.
    */
    var docID : String?
    
    //MARK: - View Updated on Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()

        // The details of the carpet recieved are updated in the appropriate fields.
        
        carpetName.text = carpet!.name
        category.text = carpet!.category
        length.text = "\(carpet!.length!)"
        breadth.text = "\(carpet!.breadth!)"
        descriptionTextView.text = carpet!.description
        
        // Image is downloaded using URL and then set in the imageview
        
        SVProgressHUD.show()
        Alamofire.request(carpet!.modelURL!).responseImage { response in
            debugPrint(response)
            
            if let image = response.result.value {
                self.carpetImage.image = image
                SVProgressHUD.dismiss()
            }
        }
    }
    
    // MARK: - Favourites Button
    
    @IBAction func addToFavourites(_ sender: UIBarButtonItem) {
        
        SVProgressHUD.show()
        
        /**
         Database reference created. The data to be added is worthless but the document to which it is added
         is important as its document ID is the same as User UID. Every carpet has a Favourites collection
         with the User UIDs of all users who have saved this carpet.
        */
        
        var ref: DocumentReference? = nil
        let data = ["wanted" : true]
        ref = self.db.collection("Favourites").document(Auth.auth().currentUser!.uid).collection("Carpets").document(self.docID!)
        
        // The data is added to the database and an alert is shown on completion.
        
        ref?.setData(data) { err in
            if let err = err {
                SVProgressHUD.dismiss()
                print("Error adding document: \(err)")
            } else {
                SVProgressHUD.dismiss()
                
                let alert = UIAlertController(title: "Success!", message: "Carpet added to favourites.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Continue", style: .default) { (action) in
                    
                }
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - AR View Called
    
    @IBAction func showCarpet(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAR", sender: self)
    }
    
    // MARK: - Details of carpet provided to make the model. Includes texture and size.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ARViewController
        destinationVC.textureURL = carpet!.modelURL
        destinationVC.length = Float(carpet!.length!) / 6299
        destinationVC.breadth = Float(carpet!.breadth!) / 6299
    }
}

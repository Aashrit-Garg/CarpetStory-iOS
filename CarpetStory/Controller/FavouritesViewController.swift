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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()
    }
    
    @IBAction func viewFavourites(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToCarpetTable", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CarpetTableViewController
        
        destinationVC.query = db.collection("Favourites").whereField("userID", isEqualTo: Auth.auth().currentUser!.uid)
    }
    
}

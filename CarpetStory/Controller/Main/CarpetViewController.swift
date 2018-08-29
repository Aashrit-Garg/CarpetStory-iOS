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
        
        SVProgressHUD.show()
        
        var ref: DocumentReference? = nil
        let data = ["wanted" : true]
        ref = self.db.collection("Carpets").document(self.docID!).collection("Favourites").document(Auth.auth().currentUser!.uid)
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
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    @IBAction func showCarpet(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAR", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ARViewController
        destinationVC.textureURL = carpet!.modelURL
        destinationVC.length = Float(carpet!.length!) / 6299
        destinationVC.breadth = Float(carpet!.breadth!) / 6299
    }
    
}

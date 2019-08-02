//
//  HomeViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 22/07/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage
import SVProgressHUD
import FirebaseFirestore
import FirebaseAuth
import FBSDKLoginKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var carpetTableView: UITableView!
    
    var carpets = [Carpet]()
    let db = Firestore.firestore()
    var index : Int?
    var docID = [String]()
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()
        SVProgressHUD.show()

        carpetTableView.delegate = self
        carpetTableView.dataSource = self
        carpetTableView.rowHeight = 250
        
        db.collection("Carpets").whereField("mostViewed", isEqualTo: true).addSnapshotListener { documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching document changes: \(error!)")
                return
            }
            for i in 0 ..< documents.count {
                let documentID = documents[i].documentID
                var addCarpet = true
                
                // Search is necessary to avoid duplication.
                
                for j in 0 ..< self.docID.count {
                    
                    if documentID == self.docID[j] {
                        addCarpet = false
                    }
                }
                
                if addCarpet == true {
                    self.getCarpetFromDoc(documentID: documentID)
                }
            }
        }
    }
    
    //MARK:- Get Document & Make Carpet Array
    
    func getCarpetFromDoc(documentID : String) {
        
        let docRef = db.collection("Carpets").document(documentID)
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let dataDescription = document.data()
                let carpet : Carpet = Carpet(
                    name: dataDescription!["name"] as? String ?? "",
                    breadth: dataDescription!["breadth"] as? Int ?? 1,
                    length: dataDescription!["length"] as? Int ?? 1,
                    modelURL: dataDescription!["modelURL"] as? String ?? "",
                    description: dataDescription!["description"] as? String ?? "",
                    category: dataDescription!["category"] as? String ?? "",
                    mostViewed: true)
                self.carpets.append(carpet)
                self.docID.append(documentID)
                
                self.carpetTableView.reloadData()
                
            } else {
                print("Document does not exist")
            }
        }
    }

    //MARK:- Logout Method
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            SVProgressHUD.dismiss()
            self.dismiss(animated: true, completion: nil)
            print("Successfully Loged Out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //MARK:- TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return carpets.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "carpetCell", for: indexPath) as! CarpetTableViewCell
        if carpets.count != 0 {
            let carpet : Carpet = carpets[indexPath.row]
            cell.carpetName.text = carpet.name
            
            if let cachedImage = imageCache.object(forKey: NSString(string: (carpet.modelURL!))) {
                
                cell.carpetImage.image = cachedImage
            } else {
                
                Alamofire.request(carpet.modelURL!).responseImage { response in
                    debugPrint(response)
                    if let image = response.result.value {
                        self.imageCache.setObject(image, forKey: NSString(string: (carpet.modelURL!)))
                        cell.carpetImage.image = image
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
        SVProgressHUD.dismiss()
        performSegue(withIdentifier: "goToCarpetDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CarpetViewController
        destinationVC.carpet = carpets[index!]
        destinationVC.docID = docID[index!]
    }
    
}

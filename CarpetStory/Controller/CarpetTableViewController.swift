//
//  CarpetTableViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 04/08/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import UIKit
import Firebase
import Alamofire
import AlamofireImage
import SVProgressHUD

class CarpetTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var carpetTableView: UITableView!
    
    var carpets = [Carpet]()
    let db = Firestore.firestore()
    var query : Query!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carpetTableView.delegate = self
        carpetTableView.dataSource = self
        carpetTableView.rowHeight = 243
        
        query.addSnapshotListener { documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching document changes: \(error!)")
                return
            }
            
            if documents.count != 0 {
                
                for i in 0 ..< documents.count {
                    let documentID = documents[i].documentID
                    self.getCarpetFromDoc(documentID: documentID)
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
    
    //MARK:- Get Document & Make Carpet Array
    
    func getCarpetFromDoc(documentID : String) {
        
        let docRef = db.collection("Carpets").document(documentID)
        
        SVProgressHUD.show()
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let dataDescription = document.data()
                
                let carpet1 : Carpet = Carpet(
                    name: dataDescription!["name"] as? String ?? "",
                    breadth: dataDescription!["breadth"] as? Int ?? 1,
                    length: dataDescription!["length"] as? Int ?? 1,
                    imageURL: dataDescription!["imageURL"] as? String ?? "",
                    modelURL: dataDescription!["modelURL"] as? String ?? "",
                    description: dataDescription!["description"] as? String ?? "",
                    category: dataDescription!["category"] as? String ?? "",
                    mostViewed: true)
                self.carpets.append(carpet1)
                
                self.carpetTableView.reloadData()
                
            } else {
                print("Document does not exist")
            }
            
            SVProgressHUD.dismiss()
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
            SVProgressHUD.show()
            Alamofire.request(carpet.imageURL!).responseImage { response in
                debugPrint(response)
                
                if let image = response.result.value {
                    cell.carpetImage.image = image
                    SVProgressHUD.dismiss()
                }
            }
        }
        
        return cell
    }
}

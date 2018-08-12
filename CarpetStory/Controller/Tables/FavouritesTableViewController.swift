//
//  FavouritesTableViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 11/08/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import UIKit
import FirebaseFirestore
import Alamofire
import AlamofireImage
import SVProgressHUD
import SwipeCellKit
import FirebaseAuth

class FavouritesTableViewController: UITableViewController {

    @IBOutlet weak var carpetTableView: UITableView!
    
    var carpets = [Carpet]()
    let db = Firestore.firestore()
    var query : Query!
    var index : Int?
    var docID = [String]()
    var isDeleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()
        
        carpetTableView.rowHeight = 243
        
        updateTableView()
    }
    
    func updateTableView() {
        
        docID = [String]()
        carpets = [Carpet]()
        
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
                                self.getCarpetFromDoc(documentID: documentID)
                            }
                        }
                    }
                }
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
                
                let carpet : Carpet = Carpet(
                    name: dataDescription!["name"] as? String ?? "",
                    breadth: dataDescription!["breadth"] as? Int ?? 1,
                    length: dataDescription!["length"] as? Int ?? 1,
                    imageURL: dataDescription!["imageURL"] as? String ?? "",
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
            
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return carpets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "carpetCell", for: indexPath) as! CarpetTableViewCell
        cell.delegate = self
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

extension FavouritesTableViewController : SwipeTableViewCellDelegate {
    
    //MARK: - Swipe Cell Delegate Methads
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            print("y")
            self.updateModel(at: indexPath)
            self.isDeleted = true
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func updateModel(at indexPath : IndexPath) {
        
        if !isDeleted {
            db.collection("Carpets").document(docID[indexPath.row]).collection("Favourites").document(Auth.auth().currentUser!.uid).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    if self.carpets.count == 1 {
                        self.carpets = [Carpet]()
                        self.docID = [String]()
                        self.tableView.reloadData()
                        self.isDeleted = false
                    } else {
                        self.carpets.remove(at: indexPath.row)
                        self.docID.remove(at: indexPath.row)
                        self.tableView.reloadData()
                        self.isDeleted = false
                    }
                }
            }
        }
    }
}

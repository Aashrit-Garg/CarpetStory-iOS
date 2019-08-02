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
    
    // MARK: - Global Variable Initialised
    
    // Two arrays to 1. store carpets for tableview. 2. store document IDs of carpetsto be sent to next view.
    var carpets = [Carpet]()
    var docID = [String]()
    
    let db = Firestore.firestore()
    
    // Used to identify which carpet has been selected by user to be sent to the next view.
    var index : Int?
    
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - View Update on Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()
        
        carpetTableView.rowHeight = 250
        
        updateTableView()
    }
    
    // MARK: - Functions that are responsible for getting the list of SAVED carpets to be displayed.
    
    // MARK: Fetch carpet list of the saved carpets by the current user.
    
    func updateTableView() {
        
        self.docID = [String]()
        self.carpets = [Carpet]()
        
        // Search is performed on the basis of current user's UID
        
        db.collection("Favourites").document(Auth.auth().currentUser!.uid).collection("Carpets").whereField("wanted", isEqualTo: true).addSnapshotListener { documentSnapshot, error in
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
    
    //MARK: Get Document & Make Carpet Array
    
    func getCarpetFromDoc(documentID : String) {
        
        let docRef = db.collection("Carpets").document(documentID)
        
        SVProgressHUD.show()
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let dataDescription = document.data()
                
                // Carpet object updated to be stored in the array.
                
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
        SVProgressHUD.dismiss()
        performSegue(withIdentifier: "goToCarpetDetail", sender: self)
    }
    
    // MARK: - The information sent to next view according to user selection.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CarpetViewController
        destinationVC.carpet = carpets[index!]
        destinationVC.docID = docID[index!]
    }
}

//MARK: - Swipe Cell Delegate Methads

extension FavouritesTableViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
        }
        
        // Cstomize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    // MARK: Function called to delete the cell from the table and database.
    
    func updateModel(at indexPath : IndexPath) {
    db.collection("Favourites").document(Auth.auth().currentUser!.uid).collection("Carpets").document(docID[indexPath.row]).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                
                if self.carpets.count == 1 {
                    self.carpets = [Carpet]()
                    self.docID = [String]()
                    self.tableView.reloadData()
                } else {
                    self.carpets.remove(at: indexPath.row)
                    self.docID.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

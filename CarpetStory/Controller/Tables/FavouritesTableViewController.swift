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

class FavouritesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var carpetTableView: UITableView!
    
    var carpets = [Carpet]()
    let db = Firestore.firestore()
    var query : Query!
    var index : Int?
    var docID : String?
    var documents : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()
        
        carpetTableView.delegate = self
        carpetTableView.dataSource = self
        carpetTableView.rowHeight = 243
        
        for i in 0 ..< documents!.count {
            self.getCarpetFromDoc(documentID: documents![i])
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
                self.docID = documentID
                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
        SVProgressHUD.dismiss()
        performSegue(withIdentifier: "goToCarpetDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CarpetViewController
        destinationVC.carpet = carpets[index!]
        destinationVC.docID = docID!
    }
    
    
}

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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var carpetTableView: UITableView!
    
//    var ls = NSHomeDirectory()
    var carpets = [Carpet]()
    let db = Firestore.firestore()
    var index : Int?
    var docID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()

        carpetTableView.delegate = self
        carpetTableView.dataSource = self
        carpetTableView.rowHeight = 243
        
        db.collection("Carpets").whereField("mostViewed", isEqualTo: true).addSnapshotListener { documentSnapshot, error in
                guard let documents = documentSnapshot?.documents else {
                    print("Error fetching document changes: \(error!)")
                    return
                }
                for i in 0 ..< documents.count {
                    let documentID = documents[i].documentID
                    self.getCarpetFromDoc(documentID: documentID)
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
                self.docID = documentID
                
                self.carpetTableView.reloadData()
                
            } else {
                print("Document does not exist")
            }
            
            SVProgressHUD.dismiss()
        }
    }

    //MARK:- Logout Method
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
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

    
//    @IBAction func downloadPressed(_ sender: UIButton) {
//
//        let urlString = "http://download1512.mediafire.com/4d8mkmam41dg/l59ktmvxl6kuuug/PersianCarpet.scn"
//        let url = URL.init(string: urlString)
//        let request = URLRequest(url: url!)
//        let session = URLSession.shared
//        let downloadTask = session.downloadTask(with: request, completionHandler: { (location:URL?, response:URLResponse?, error:Error?)
//            -> Void in
//            print("location:\(String(describing: location))")
//            let locationPath = location!.path
//            let documents:String = NSHomeDirectory() + "/Documents/carpet.scn"
//            self.ls = NSHomeDirectory() + "/Documents"
//            let fileManager = FileManager.default
//            if (fileManager.fileExists(atPath: documents)){
//                try! fileManager.removeItem(atPath: documents)
//            }
//            try! fileManager.moveItem(atPath: locationPath, toPath: documents)
//            print("new location:\(documents)")
//        })
//        downloadTask.resume()
//
//        performSegue(withIdentifier: "goToAR", sender: self)
//
//
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let destinationVC = segue.destination as! ARViewController
//        destinationVC.path = ls
//    }
}

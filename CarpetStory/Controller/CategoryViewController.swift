//
//  CategoryViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 04/08/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var categories = ["Modern", "Classical", "Heritage", "Shallymar"]
    var condition : String?
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryLabel.text = categories[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        condition = categories[indexPath.item]
        performSegue(withIdentifier: "goToCarpetTable", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CarpetTableViewController
        
        destinationVC.query = db.collection("Carpets").whereField("category", isEqualTo: condition!)
    }

}

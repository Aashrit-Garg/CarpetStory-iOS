//
//  HomeViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 22/07/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

//    var ls = NSHomeDirectory()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedlogout(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.dismiss(animated: true, completion: nil)
            print("Sucesssssss")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
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

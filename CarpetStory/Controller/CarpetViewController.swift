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

class CarpetViewController: UIViewController {

    @IBOutlet weak var carpetName: UILabel!
    @IBOutlet weak var carpetImage: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var breadth: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    
    var carpet : Carpet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

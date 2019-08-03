//
//  MainTabBarController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 27/07/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item \(item.title)")
    }
}

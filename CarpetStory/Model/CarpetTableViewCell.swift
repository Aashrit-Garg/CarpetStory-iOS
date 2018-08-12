//
//  CarpetTableViewCell.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 02/08/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import SwipeCellKit

class CarpetTableViewCell: SwipeTableViewCell {

    
    @IBOutlet weak var carpetImage: UIImageView!
    @IBOutlet weak var carpetName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

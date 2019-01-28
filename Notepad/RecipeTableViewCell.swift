//
//  RecipeTableViewCell.swift
//  Notepad
//
//  Created by Pooja Nadkarni on 1/19/19.
//  Copyright © 2019 Pooja Nadkarni. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

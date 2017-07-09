//
//  DotsTableViewCell.swift
//  Dropr
//
//  Created by Josh Peters on 4/11/17.
//  Copyright © 2017 GarrettPeters. All rights reserved.
//

import UIKit

class DotsTableViewCell: UITableViewCell {

    @IBOutlet weak var redGreenDotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

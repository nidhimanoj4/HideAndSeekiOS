//
//  DistTableViewCell.swift
//  Hide-And-Seek
//
//  Created by Neena Dugar on 30/07/2017.
//  Copyright © 2017 Nidhi Manoj. All rights reserved.
//

import UIKit

class DistTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

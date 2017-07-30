//
//  PlayerListTableViewCell.swift
//  Hide-And-Seek
//
//  Created by Neena Dugar on 29/07/2017.
//  Copyright © 2017 Nidhi Manoj. All rights reserved.
//

import UIKit

class PlayerListTableViewCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

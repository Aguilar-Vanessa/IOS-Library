//
//  TableViewCell.swift
//  Library
//
//  Created by Vanessa Aguilar on 11/28/20.
//  Copyright © 2020 Personal Team. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var authorCell: UILabel!
    @IBOutlet weak var releaseCell: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  SalesTableViewCell.swift
//  Masquepan
//
//  Created by dam on 07/03/2018.
//  Copyright © 2018 dam. All rights reserved.
//

import UIKit

class SalesTableViewCell: UITableViewCell {
    @IBOutlet weak var idticketlabel: UILabel!
    @IBOutlet weak var dateticketlabel: UILabel!
    @IBOutlet weak var memberticketlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

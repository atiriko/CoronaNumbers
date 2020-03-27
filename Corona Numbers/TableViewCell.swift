//
//  TableViewCell.swift
//  Corona Numbers
//
//  Created by Atahan on 20/03/2020.
//  Copyright © 2020 AtahanSahlan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var confirmed: UILabel!
    @IBOutlet weak var recovered: UILabel!
    @IBOutlet weak var death: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

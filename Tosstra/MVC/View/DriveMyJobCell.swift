//
//  DriveMyJobCell.swift
//  Tosstra
//
//  Created by Eweb on 04/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class DriveMyJobCell: UITableViewCell {
    @IBOutlet weak var userNaleLb: UILabel!
    
    @IBOutlet weak var startBtn: RoundedButton!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

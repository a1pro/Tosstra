//
//  SettingTCell.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class SettingTCell: UITableViewCell {

    @IBOutlet weak var offOnSwicth: UISwitch!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var itleLbl: UILabel!
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

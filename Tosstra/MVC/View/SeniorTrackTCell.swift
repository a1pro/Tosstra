//
//  SeniorTrackTCell.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class SeniorTrackTCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var trsportName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

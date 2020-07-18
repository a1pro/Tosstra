//
//  DriverHomeCCell.swift
//  Tosstra
//
//  Created by Eweb on 17/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class DriverHomeCCell: UICollectionViewCell {
    @IBOutlet weak var backView: CardView!
       @IBOutlet weak var profileImg: UIImageView!
       
    @IBOutlet weak var aceeptBtn: RoundedButton!
    @IBOutlet weak var rejectBtn: RoundedButton!
    @IBOutlet weak var stackView: UIStackView!
    // @IBOutlet weak var dropLbl: UILabel!
       //@IBOutlet weak var pickeUpLbl: UILabel!
       @IBOutlet weak var priceLbl: UILabel!
       @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

//
//  ClusterCollectionCell.swift
//  Tosstra
//
//  Created by Eweb on 09/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class ClusterCollectionCell: UICollectionViewCell {
    @IBOutlet weak var backView: CardView!
    @IBOutlet weak var profileImg: UIImageView!
    
   // @IBOutlet weak var dropLbl: UILabel!
    //@IBOutlet weak var pickeUpLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

//
//  markerDetailView.swift
//  Tosstra
//
//  Created by Eweb on 08/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

class markerDetailView: UIView {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
      override init(frame: CGRect) {
            super.init(frame: frame)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    //        self.groupName.layer.cornerRadius = self.groupName.frame.height/2
        }

   func loadView() -> markerDetailView
   {
       let customInfoWindow = Bundle.main.loadNibNamed("DriverMarkerView", owner: self, options: nil)?[0] as! markerDetailView
       return customInfoWindow
   }

}

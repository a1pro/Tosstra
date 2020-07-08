//
//  CustomMarkerView.swift
//  Tosstra
//
//  Created by Eweb on 08/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit

import Foundation
import UIKit

class CustomMarkerView: UIView {
    var img: UIImage!
    var borderColor: UIColor!
    
    init(frame: CGRect, image: UIImage, borderColor: UIColor, tag: Int) {
        super.init(frame: frame)
        self.img=image
      //  self.borderColor=borderColor
        self.tag = tag
        setupViews()
    }
    
    func setupViews()
    { //47 // 65  -- > 50 /50
        let imgView = UIImageView(image: img)
        imgView.frame=CGRect(x: 0, y: 0, width: 47, height: 65)
        imgView.layer.cornerRadius = 25
      //  imgView.layer.borderColor=borderColor?.cgColor
       // imgView.layer.borderWidth=4
       // imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds=true
        let lbl=UILabel(frame: CGRect(x: 0, y: 45, width: 50, height: 10))
      //  lbl.text = "▾"
        lbl.font=UIFont.systemFont(ofSize: 24)
       // lbl.textColor = borderColor
        lbl.textAlignment = .center
        
        self.addSubview(imgView)
        self.addSubview(lbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  DisjobDescriptionVC.swift
//  Tosstra
//
//  Created by Eweb on 03/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController

class DisjobDescriptionVC: UIViewController {
   @IBOutlet var addInfoText:UITextView!
   @IBOutlet var segmentedControl:UISegmentedControl!
   @IBOutlet var segmentOuterView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addInfoText.layer.borderColor = UIColor.lightGray.cgColor
        self.addInfoText.layer.borderWidth = 1
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        let titleTextAttributes2 = [NSAttributedString.Key.foregroundColor: APPCOLOL]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes2, for: .normal)
        
        self.segmentedControl.layer.cornerRadius = segmentOuterView.bounds.height / 2
        self.segmentedControl.layer.borderColor = UIColor.white.cgColor
        self.segmentedControl.layer.borderWidth = 1
        self.segmentedControl.layer.masksToBounds = true

        segmentOuterView.layer.cornerRadius = segmentOuterView.bounds.height / 2
        segmentOuterView.layer.borderColor = UIColor.blue.cgColor
        segmentOuterView.layer.borderWidth = 1
        
        
       
    }
    @IBAction func MenuAct(_ sender: UIButton)
    {
        let drawer = navigationController?.parent as? KYDrawerController
        drawer?.setDrawerState(.opened, animated: true)
    }
}
class CustomSegmentedControl: UISegmentedControl {

    override func layoutSubviews(){

        super.layoutSubviews()

        //corner radius
        let cornerRadius = bounds.height/2
        let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        //background
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: 5, dy: 5)
            foregroundImageView.image = UIImage()
            foregroundImageView.highlightedImage = UIImage()
            foregroundImageView.backgroundColor = UIColor.darkGray
            foregroundImageView.clipsToBounds = true
            foregroundImageView.layer.masksToBounds = true

            foregroundImageView.layer.cornerRadius = 14
            foregroundImageView.layer.maskedCorners = maskedCorners
        }
    }
}

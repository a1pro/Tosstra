//
//  CardView.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//


import Foundation
import UIKit

@IBDesignable class CardView: UIView
{
    
    @IBInspectable var cornerRedius:CGFloat = 10
    @IBInspectable   var shadowOffWidth:CGFloat = 0
    @IBInspectable  var shadowoffHeight:CGFloat = 2
    @IBInspectable  var shadowColor:UIColor = UIColor.clear
    @IBInspectable  var shadowOpecity:CGFloat = 1
    
    
    
    override func layoutSubviews()
    {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = Float(shadowOpecity)
        //   backgroundColor = UIColor.gray
        layer.shadowOffset = CGSize(width: shadowOffWidth, height: shadowoffHeight)
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRedius)
        layer.shadowPath = path.cgPath
        
        layer.cornerRadius = cornerRedius//10
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
}

@IBDesignable
class CustomSlider: UISlider {
    /// custom slider track height
    @IBInspectable var trackHeight: CGFloat = 3
    @IBInspectable var cornerRedius:CGFloat = 2
    @IBInspectable   var shadowOffWidth:CGFloat = 0
    @IBInspectable  var shadowoffHeight:CGFloat = 2
    @IBInspectable  var shadowColor:UIColor = UIColor.black
    @IBInspectable  var shadowOpecity:CGFloat = 1
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Use properly calculated rect
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        
        
    }
    
    func RightRoundCorners()
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    func SignupRightRoundCorners()
       {
           self.clipsToBounds = true
           self.layer.cornerRadius = 50
           
           self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
           self.layer.borderWidth = 1
           self.layer.borderColor = UIColor.lightGray.cgColor
       }
    func TopRoundCorners()
         {
             self.clipsToBounds = true
             self.layer.cornerRadius = 20
             
             self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
             self.layer.borderWidth = 1
             self.layer.borderColor = UIColor.white.cgColor
         }
      func ButtomRoundCorners()
              {
                  self.clipsToBounds = true
                  self.layer.cornerRadius = 20
                  
                self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                  self.layer.borderWidth = 1
                  self.layer.borderColor = UIColor.white.cgColor
              }
           
    
    func RightRoundCornersWithShadow()
    {
        
        let shadowOffWidth:CGFloat = 0
        let shadowoffHeight:CGFloat = 2
        var _:UIColor = UIColor.clear
        let shadowOpecity:CGFloat = 1
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = Float(shadowOpecity)
        
        layer.shadowOffset = CGSize(width: shadowOffWidth, height: shadowoffHeight)
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2)
        layer.shadowPath = path.cgPath
        self.layer.cornerRadius = self.frame.height/2
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    func LeftRoundCornersWithShadow()
      {
          
          let shadowOffWidth:CGFloat = 0
          let shadowoffHeight:CGFloat = 2
          var _:UIColor = UIColor.clear
          let shadowOpecity:CGFloat = 1
          
          layer.shadowColor = UIColor.lightGray.cgColor
          layer.shadowOpacity = Float(shadowOpecity)
          
          layer.shadowOffset = CGSize(width: shadowOffWidth, height: shadowoffHeight)
          let path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2)
          layer.shadowPath = path.cgPath
          self.layer.cornerRadius = self.frame.height/2
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
          
          layer.borderWidth = 0.8
          layer.borderColor = UIColor.lightGray.cgColor
          
      }
}
extension UIView {
    func ToproundCorners(corners: UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

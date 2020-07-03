//
//  Constant.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import Foundation
import UIKit




let DEFAULT = UserDefaults.standard
let APPCOLOL = UIColor.init(red: 54/255, green: 41/255, blue: 230/255, alpha: 1)
let PROFILECOLOL = UIColor.init(red: 95/255, green: 122/255, blue: 207/255, alpha: 1)
let APPTEXTLIGHTCOLOL = UIColor.init(red: 135/255, green: 158/255, blue: 183/255, alpha: 1)

let STATUSBARCOLOR2 = UIColor.init(red: 244/255, green: 247/255, blue: 255/255, alpha: 1)
let STATUSBARCOLOR = UIColor.init(red: 233/255, green: 238/255, blue: 255/255, alpha: 1)

let APPTEXTCOLOL = UIColor.init(red: 106/255, green: 134/255, blue: 165/255, alpha: 1)

let SELECTEDLINECOLOL = UIColor.init(red: 94/255, green: 127/255, blue: 158/255, alpha: 1)
let DELETEACCOUNTCOLOL = UIColor.init(red: 255/255, green: 110/255, blue: 64/255, alpha: 1)

let VIEWGALLYCOLOL = UIColor.init(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
let YELLOWMARKERCOLOL = UIColor.init(red: 255/255, green: 159/255, blue: 0/255, alpha: 1)

let CALENDERCOLOL = UIColor.init(red: 35/255, green: 48/255, blue: 64/255, alpha: 1)
let FINDCOLOL = UIColor.init(red: 156/255, green: 177/255, blue: 194/255, alpha: 1)

let APPDEL = UIApplication.shared.delegate  as! AppDelegate
let SCREENWIDTH = UIScreen.main.bounds.width
let SCREENHEIGHT = UIScreen.main.bounds.height
let TOPHEIGHT = UIApplication.shared.statusBarFrame.height + 60.0
let CURRENTTIMEZONE = Calendar.current.timeZone.identifier
let latX = DEFAULT.value(forKey: "CURRENTLAT") as? String ?? "30.0"
let longX = DEFAULT.value(forKey: "CURRENTLONG") as? String ?? "76.0"
var CURRENTLOCATIONLAT = Double(latX)!
var CURRENTLOCATIONLONG = Double(longX)!



@available(iOS 13.0, *)
let SCENEDEL = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate

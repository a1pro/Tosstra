//
//  WebServices.swift
//  Tosstra
//
//  Created by Eweb on 06/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import Foundation



//MARK:- all websevices

//let BASEURL = "http://a1professionals.net/tosstra/api/"
//
//let IMAGEBASEURL = "http://a1professionals.net/tosstra/assets/usersImg/"
//
//let VIDEOBASEURL = "https://a1professionals.net/dressApp/assets/videos/"
////1.
//
//let Privacy = "https://tosstra.com/privacy-policy"
//
//let Terms_and_Conditions = "https://tosstra.com/terms-and-conditi"
//
//let CONTACTUS = "https://tosstra.com/contact-us"
//
//let HELP = "https://tosstra.com/help"


let BASEURL = "http://tosstra.tosstra.com/api/"

let IMAGEBASEURL = "http://tosstra.tosstra.com/assets/usersImg/"

let VIDEOBASEURL = "http://tosstra.tosstra.com/assets/videos/"
//1.

let Privacy = "https://tosstra.com/privacy-policy"

let Terms_and_Conditions = "https://tosstra.com/terms-and-conditions"

let CONTACTUS = "https://tosstra.com/contact-us"

let HELP = "https://tosstra.com/help"

//MARK:- Dispatcher API


let DISPATCHER_REGISTER_API = BASEURL + "dispatcher-Register"

let DISPATCHER_LOGIN_API = BASEURL + "user-Login"

let VIEW_PROFILE_API = BASEURL + "view-Profile"

let EDIT_PROFILE_API = BASEURL + "edit-Profile"

let LOGOUT_PROFILE_API = BASEURL + "user-logOut"


let DELETE_PROFILE_API = BASEURL + "delete-Account"

let FORGOT_PASSWORD_API = BASEURL + "forgot-Password"

let RECOVER_PASSWORD_API = BASEURL + "recover-Passwrod"

let CHANGE_PASSWORD_API = BASEURL + "change-Password"

let CHANGE_ONLINESTATUS_API = BASEURL + "change-Online-Status"

let CREATE_JOB_API = BASEURL + "create-Job-By-dispatcher"

let GET_ALL_DRIVER_API = BASEURL + "get-All-Drivers"

let GET_FAV_DRIVER_API = BASEURL + "get-Only-FavDrivers"

let driver_Favorite_Unfavorite_API = BASEURL + "driver-Favorite-Unfavorite"


let GET_DIS_NOTI_API = BASEURL + "get-Dispatcher-Nofitications"

let GET_ACTIVE_DRIVER_API = BASEURL + "active-Driver-List"


//MARK:- Driver API

let DRIVER_REGISTER_API = BASEURL + "driver-Register"

let GET_ALLJOB_API = BASEURL + "get-All-Jobs-To-drivers"

let ACEEPT_REJECT_JOB_API = BASEURL + "job-Accecpt-Reject"

let GET_MY_JOB_API = BASEURL + "get-Our-All-Jobs"

let START_JOB_API = BASEURL + "work-Start-Status"


let GET_DRIVER_NOTI_API = BASEURL + "get-Driver-Nofitications"

let DRIVER_COPLETE_API = BASEURL + "job-Complete-Status"

let END_JOB_API = BASEURL + "end-Driver-Job"


let JOB_DETAILS_API = BASEURL + "get-Single-Job-Data"

let NOTIFICATION_15MINS_API = BASEURL + "driver-Location-Point"

let UPADATEPAYMENTAPI = BASEURL + "user-Payment"

let ADDLOGBOOKAPI = BASEURL + "logBook"

let GETLOGBOOKAPI = BASEURL + "getDriverLogBook"



//
//  ActiveDriverVC.swift
//  Tosstra
//
//  Created by Eweb on 02/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import KYDrawerController
import GoogleMaps
import GooglePlaces
import CoreLocation
import SVProgressHUD

class ActiveDriverVC: UIViewController {
    
    @IBOutlet var myTable:UITableView!
    var apiData:ForgotPasswordModel?
    @IBOutlet var listLineView:UIView!
    @IBOutlet var mapLineView:UIView!
    @IBOutlet var listView:UIView!
    @IBOutlet var mapView:UIView!
    //MARK:- Market task
    var allMarkerArray = NSMutableArray()
    var allMarkerArray2 = NSMutableArray()
    
    var geoCoder:CLGeocoder!
    var destinationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 37.0, longitude: 45.0))
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    public var longitude:Double = 77.38066792488098
    public var latitude:Double = 28.6517752463408
    
    var onlineStatus = "0"
    var markers = [GMSMarker]()
    
    var selectedMarkerIndex=0
    var customInfoWindow : markerDetailView?
    var tappedMarker : GMSMarker?
    
    @IBOutlet weak var myMapView: GMSMapView!
    
    var selectedDriverArray = NSMutableArray()
    var selectedgroupCatArray = NSMutableArray()
    var checkArray = NSMutableArray()
    @IBOutlet var pBtn:UIButton!
    
    //MARK:- Collection setup
    
    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var clusterView: UIView!
    
    
    var jobIds = ""
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var refrshBtn: UIButton!
    
    @IBOutlet weak var endBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate=self
        myTable.dataSource=self
         refrshBtn.isHidden=true
        myTable.separatorStyle = .none
        myTable.register(UINib(nibName: "ActiveDriverTCell", bundle: nil), forCellReuseIdentifier: "ActiveDriverTCell")
        
        myTable.register(UINib(nibName: "DisEndJonTCell", bundle: nil), forCellReuseIdentifier: "DisEndJonTCell")
        
        self.mapView.isHidden = true
        self.listView.isHidden = false
        self.customInfoWindow = markerDetailView().loadView()
        initGoogleMaps()
        self.collectionSetup()
        self.clusterView.isHidden = false
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.allActiveDriverAPI()
        }
        if #available(iOS 10.0, *) {
            self.myTable.refreshControl = refreshControl
        } else {
            self.myTable.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any)
    {
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.allActiveDriverAPI()
        }
    }
    @IBAction func MenuAct(_ sender: UIButton)
    {
        let drawer = navigationController?.parent as? KYDrawerController
        drawer?.setDrawerState(.opened, animated: true)
    }
    
    @IBAction func listViewAct(_ sender: UIButton)
    {
        //self.truckType = "all"
        self.listLineView.backgroundColor = APPCOLOL
        self.mapLineView.backgroundColor = UIColor.lightGray
        self.mapView.isHidden = true
        self.listView.isHidden = false
        refrshBtn.isHidden=true
        self.clusterView.isHidden = true
        self.myTable.reloadData()
        
    }
    
    @IBAction func mapViewAct(_ sender: UIButton)
    {
        refrshBtn.isHidden=false
        self.mapView.isHidden = false
        self.listView.isHidden = true
        self.listLineView.backgroundColor = UIColor.lightGray
        self.mapLineView.backgroundColor = APPCOLOL
        self.myCollection.reloadData()
        self.clusterView.isHidden = false
        self.myTable.reloadData()
    }
    
    @IBAction func refreshAct(_ sender: UIButton)
       {
          if !(NetworkEngine.networkEngineObj.isInternetAvailable())
          {
              NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
          }
          else
          {
              self.allActiveDriverAPI()
          }
       }
    
    @objc func PhoneCallAct(_ sender:UIButton)
    {
        
        if let dict = self.allMarkerArray.object(at: sender.tag) as? NSDictionary
        {
            let phone = (dict.value(forKey: "phone") as? String ?? "")
            guard let number = URL(string: "tel://" + phone) else { return }
            UIApplication.shared.open(number)
        }
    }
    @IBAction func endJobAct(_ sender:UIButton)
    {
        
        
        
        
        if self.checkArray.count>0
        {
             let alert = UIAlertController(title: "Alert", message: "Are you sure you want to end job?", preferredStyle: UIAlertController.Style.alert)
                 alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                     print("Handle Cancel Logic here")
                 }))
                 alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                     if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                     {
                         NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                     }
                     else
                     {
                         if !(NetworkEngine.networkEngineObj.isInternetAvailable())
                         {
                             NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
                         }
                         else
                         {
                             
                             
                             self.jobIds = self.selectedDriverArray.componentsJoined(by: ",")
                             self.EndJobStartAPI()
                             
                             
                         }
                     }
                     
                     
                 }))
                 
                 present(alert, animated: true, completion: nil)
            
        }
        else
        {
           NetworkEngine.commonAlert(message: "Please select driver to end job.", vc: self)
            
        }
     
    }
    
    
    
    @objc func AllTrackcheckAct(_ sender:UIButton)
    {
        
        
        if self.selectedDriverArray.count>0
        {
            self.selectedDriverArray.removeAllObjects()
        }
        if self.selectedgroupCatArray.count>0
        {
            self.selectedgroupCatArray.removeAllObjects()
        }
        
        if self.checkArray.contains(sender.tag)
        {
            self.checkArray.remove(sender.tag)
        }
        else
        {
            self.checkArray.add(sender.tag)
        }
        print("check array = \(self.checkArray)")
        
        
        self.myTable.reloadData()
        
    }
    
    
    
}
extension ActiveDriverVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.allMarkerArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveDriverTCell") as! ActiveDriverTCell
        cell.checkBtn.tag = indexPath.row
        cell.checkBtn.addTarget(self, action: #selector(AllTrackcheckAct), for: UIControl.Event.touchUpInside)
        
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(PhoneCallAct), for: UIControl.Event.touchUpInside)
        
        
        if let dict = self.allMarkerArray.object(at: indexPath.row) as? NSDictionary
        {
            cell.trsportName.text = (dict.value(forKey: "companyName") as? String ?? "")
            
            cell.userName.text = (dict.value(forKey: "firstName") as? String ?? "")
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            if self.checkArray.contains(indexPath.row)
            {
                let id = dict.value(forKey: "jobId") as? String
                
                if self.selectedDriverArray.contains(id)
                {
                    
                }
                else
                {
                    self.selectedDriverArray.add(id)
                    
                }
                
                
                cell.checkBtn.setImage(UIImage(named: "check-box"), for: .normal)
            }
            else
            {
                cell.checkBtn.setImage(UIImage(named: "check-box-1"), for: .normal)
            }
            
        }
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisJobDetailsVC") as! DisJobDetailsVC
        
        if let dict = self.allMarkerArray.object(at: indexPath.row) as? NSDictionary
        {
            vc.fromNoti = "no"
            vc.jobId = dict.value(forKey: "jobId") as? String ?? ""
            vc.dispatcherId = dict.value(forKey: "dispatcherId") as? String ?? ""
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "DisEndJonTCell") as! DisEndJonTCell
    //
    //       // cell.endJob.addTarget(self, action: #selector(endJobAct), for: UIControl.Event.touchUpInside)
    //
    //
    //
    //        return cell
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    //    {
    //    return 110
    //    }
}

extension ActiveDriverVC
{
    //MARK:- allActiveDriverAPI API
    
    func allActiveDriverAPI()
    {
        
        
        
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id]   as [String : String]
        
        ApiHandler.PostMethod(url: GET_ACTIVE_DRIVER_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                self.refreshControl.endRefreshing()
                if let dict = response as? NSDictionary
                {
                    if let dataArray = dict.value(forKey: "data") as? NSArray
                    {
                        
                        self.allMarkerArray = dataArray.mutableCopy() as! NSMutableArray
                        
                        
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        NetworkEngine.commonAlert(message: dict.value(forKey: "message") as? String ?? "", vc: self)
                    }
                    
                    
                    
                    if self.allMarkerArray.count == 0
                    {
                        self.endBtn.isHidden = true
                    }
                    else
                    {
                        self.endBtn.isHidden = false
                    }
                    
                    
                    
                    
                }
                self.myTable.reloadData()
                
                self.showPartyMarkers()
            }
            else
            {
               
                 NetworkEngine.showToast(controller: self, message: error)
            }
        }
    }
    func showPartyMarkers()
    {
        myMapView.clear()
        if markers.count>0
        {
            self.markers.removeAll()
        }
        
        for i in 0..<self.allMarkerArray.count
        {
            if  let dict = self.allMarkerArray.object(at: i) as? NSDictionary
            {
                
                
                
                
                let lat = Double(dict.value(forKey: "latitude") as? String ?? "30.0")
                let long = Double(dict.value(forKey: "longitude") as? String ?? "76.00")
                
                if lat != nil || long != nil
                {
                    let marker=GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                    
                    marker.icon = UIImage(named: "selectedmarker")
                    self.markers.append(marker)
                    marker.map = self.myMapView
                }
                
            }
        }
    }
    
    //MARK:- JoBStartAPI Api
    
    func EndJobStartAPI()
    {
        var id = ""
        if let userID = DEFAULT.value(forKey: "USERID") as? String
        {
            id = userID
        }
        
        let params = ["userId" : id,
                      "jobId" : self.jobIds]   as [String : String]
        
        ApiHandler.ModelApiPostMethod(url: END_JOB_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                   // self.allActiveDriverAPI()
                    self.apiData = try decoder.decode(ForgotPasswordModel.self, from: response!)
                    
                    self.myTable.reloadData()
                    
                    let elDrawer = self.navigationController?.parent as? KYDrawerController
                    let home = self.storyboard?.instantiateViewController(withIdentifier: "ActiveDriverVC") as? ActiveDriverVC
                    
                    
                    let _nav = UINavigationController(rootViewController: home ?? UIViewController())
                    _nav.isNavigationBarHidden = true
                    elDrawer?.mainViewController = _nav
                    elDrawer?.setDrawerState(.closed, animated: true)
                    
                    
                    
                    
                }
                catch let error
                {
                    self.view.makeToast(error.localizedDescription)
                }
                
            }
            else
            {
                self.view.makeToast(error)
            }
        }
    }
    
}
//MARK:- Map Work

extension ActiveDriverVC:GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate
{
    @objc func btnMarkerDetails(_ sender:UIButton)
    {
        print("btnGroupDetails click")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisJobDetailsVC") as! DisJobDetailsVC
        
        if let dict = self.allMarkerArray.object(at: sender.tag) as? NSDictionary
               {
                   vc.fromNoti = "no"
                   vc.jobId = dict.value(forKey: "jobId") as? String ?? ""
                   vc.dispatcherId = dict.value(forKey: "dispatcherId") as? String ?? ""
               }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: CLLocation Manager Delegate
    
    //MARK:- Map init code
    func initGoogleMaps() {
        //        let camera = GMSCameraPosition.camera(withLatitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG, zoom: 17.0)
        
        let camera = GMSCameraPosition.camera(withLatitude: CURRENTLOCATIONLAT, longitude: CURRENTLOCATIONLONG, zoom: 6.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.settings.compassButton = true
        self.myMapView.settings.myLocationButton=true
        self.myMapView.isMyLocationEnabled = true
        self.myMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 170, right: 0)
        
        showPartyMarkers()
    }
    
    //MARK:-  Marker tap
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        NSLog("marker was tapped")
        tappedMarker = marker
        
        
        
        
        marker.icon = UIImage(named: "selectedmarker")
        //get position of tapped marker
        let position = marker.position
        mapView.animate(toLocation: position)
        let point = mapView.projection.point(for: position)
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
        
        let opaqueWhite = UIColor(white: 1, alpha: 0.85)
        customInfoWindow?.layer.backgroundColor = opaqueWhite.cgColor
        customInfoWindow?.layer.cornerRadius = 8
        customInfoWindow?.center = mapView.projection.point(for: position)
        customInfoWindow?.center.y -= 100
        
        customInfoWindow?.backgroundColor = UIColor.clear
        
        if let index = markers.index(of: marker)
        {
            self.selectedMarkerIndex=index
            
            
            
            print(index)
            if self.allMarkerArray.count>0
            {
                if let dict = self.allMarkerArray.object(at: index) as? NSDictionary
                {
                    
                    customInfoWindow?.userName.layer.cornerRadius = ((customInfoWindow?.userName.frame.height ?? 5)/2)
                    customInfoWindow?.userName.contentMode = .scaleAspectFill
                    customInfoWindow?.userName.clipsToBounds = true
                    
                    customInfoWindow?.profileImg.layer.cornerRadius = ((customInfoWindow?.profileImg.frame.height ?? 90)/2)
                    
                    customInfoWindow?.profileImg.contentMode = .scaleAspectFill
                    customInfoWindow?.profileImg.clipsToBounds = true
                    
                    customInfoWindow?.userName.text  = dict.value(forKey: "companyName") as? String ?? ""
                    
                    if let groupIcon = dict.value(forKey: "profileImg") as? String
                        
                    {
                        if groupIcon != ""
                        {
                            let fullurl = IMAGEBASEURL + groupIcon
                            let url = URL(string: fullurl)!
                            customInfoWindow?.profileImg.image = nil
                            customInfoWindow?.profileImg.sd_setImage(with: url, completed: nil)
                        }
                        else
                        {
                            
                            customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
                        }
                        
                    }
                    else
                    {
                        
                        
                        customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
                        
                    }
                    customInfoWindow?.profileBtn.tag = Int(dict.value(forKey: "jobId") as! String)!
                    
                }
                customInfoWindow?.profileBtn.tag = index
                customInfoWindow?.profileBtn.addTarget(self, action: #selector(btnMarkerDetails), for: .touchUpInside)
                // marker.iconView = customInfoWindow
                mapView.addSubview(customInfoWindow!)
            }
            
            
            
            
        }
        else
            
        {
            customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
            
            print(marker)
        }
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.icon = UIImage(named: "selectedmarker")
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        // customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        
        
        customInfoWindow?.removeFromSuperview()
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        let position = tappedMarker?.position
        //  customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
        if position != nil
        {
            customInfoWindow?.center = mapView.projection.point(for: position!)
            customInfoWindow?.center.y -= 100
        }
        if let marker =  mapView.selectedMarker
        {
            
            //  customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        }
        else
        {
            // customInfoWindow?.markerBtn.setBackgroundImage(#imageLiteral(resourceName: "MarkerImage"), for: .normal)
            //customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        }
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker)
    {
        print("amar d gh h df")
        if let marker =  mapView.selectedMarker
        {
            // customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
            
        }
        
    }
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView?
    {
        let imageIcon = UIButton(frame: CGRect(x: 25, y: 0, width: 50, height: 50))
        imageIcon.setBackgroundImage(UIImage(named: "AppIcon-2"), for: .normal)
        
        //customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        //view.addSubview(imageIcon)
        
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        // let data = previewDemoData[customMarkerView.tag]
        //restaurantPreviewView.setData(img:UIImage(named: "AppIcon-2")!)
        return UIView()//restaurantPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        //customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        
        marker.icon = UIImage(named: "selectedmarker")
        // customInfoWindow?.profileImg.setImage(string: customInfoWindow?.userName.text, color: APPCOLOL, circular: true,textAttributes: attrs)
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        // showPartyMarkers(lat: lat, long: long)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        myMapView.camera = camera
        //  txtFieldSearch.text=place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: lat, long: long)
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = myMapView
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationCheck()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                locationManager.startMonitoringSignificantLocationChanges()
                
            }
        }
        else {
            print("Location services are not enabled")
            
            
        }
    }
    
}
extension ActiveDriverVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func collectionSetup()
    {
        self.myCollection.delegate = self
        myCollection.dataSource = self
        
        
        self.myCollection.register(UINib(nibName: "ClusterCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ClusterCollectionCell")
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.allMarkerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClusterCollectionCell", for: indexPath) as! ClusterCollectionCell
        
        if let dict = self.allMarkerArray.object(at: indexPath.row) as? NSDictionary
        {
            
            cell.nameLbl.text  = "Company Name - " + (dict.value(forKey: "companyName") as? String ?? "")
            
            //        let d_add = (dict.value(forKey: "drpStreet") as? String ?? "") + " " + (dict.value(forKey: "drpCity") as? String ?? "")
            //
            //              let d =  (dict.value(forKey: "drpState") as? String ?? "" ?? "") + " " + (dict.value(forKey: "drpZipcode") as? String ?? "")
            //
            //       // cell.dropLbl.text = "Drop off - " + d_add + " " + d
            //
            //              let p_add = (dict.value(forKey: "pupStreet") as? String ?? "") + " " + (dict.value(forKey: "pupCity") as? String ?? "")
            //
            //                 let p = (dict.value(forKey: "pupState") as? String ?? "" ?? "") + " " + (dict.value(forKey: "pupZipcode") as? String ?? "")
            //
            //
            //      //  cell.pickeUpLbl.text = "Pick up - " + p_add + " " + p
            //
            
            
            //let rate = dict.value(forKey: "rateType") as? String ?? ""
            
            //        if rate == "perHours"
            //        {
            //          cell.priceLbl.text =  "$ " + (dict.value(forKey: "rate") as? String ?? "") + " " + ("per Hours")
            //        }
            //        else
            //        {
            //            cell.priceLbl.text =   "$ " + (dict.value(forKey: "rate") as? String ?? "") + " " + ("per Load")
            //        }
            cell.priceLbl.text =   (dict.value(forKey: "firstName") as? String ?? "")
            
            cell.profileImg.layer.cornerRadius = cell.profileImg.bounds.height/2
            cell.profileImg.contentMode = .scaleAspectFill
            cell.profileImg.clipsToBounds = true
            
            if let groupIcon = dict.value(forKey: "profileImg") as? String
                
            {
                if groupIcon != ""
                {
                    let fullurl = IMAGEBASEURL + groupIcon
                    let url = URL(string: fullurl)!
                    cell.profileImg.image = nil
                    cell.profileImg.sd_setImage(with: url, completed: nil)
                }
                else
                {
                    
                    cell.profileImg.setImage(string: (dict.value(forKey: "companyName") as? String ?? "") , color: APPCOLOL, circular: true,textAttributes: attrs)
                }
                
            }
            else
            {
                
                
                cell.profileImg.setImage(string: (dict.value(forKey: "companyName") as? String ?? ""), color: APPCOLOL, circular: true,textAttributes: attrs)
                
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisJobDetailsVC") as! DisJobDetailsVC
       
        if let dict = self.allMarkerArray.object(at: indexPath.row) as? NSDictionary
        {
            vc.fromNoti = "no"
            vc.jobId = dict.value(forKey: "jobId") as? String ?? ""
            vc.dispatcherId = dict.value(forKey: "dispatcherId") as? String ?? ""
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: SCREENWIDTH-8, height: 150)
    }
    
}

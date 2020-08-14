//
//  TrackLoactionVC.swift
//  Tosstra
//
//  Created by Eweb on 17/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//

import UIKit
import MapKit

class TrackLoactionVC: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var refrshBtn: UIButton!
    
    var sourceLat = "30.7041"
    var sourceLong = "76.1025"
    var destinationLat = "28.7041"
    var destinationLong = "77.1025"
    
    var sourceAdd = ""
    var destinationAdd = ""
    
    let annotation = MKPointAnnotation()
    
    var driverLat = ""
    var driverLong = ""
    
    
    var fromTrackDriver = ""
    var JobDetailData:JobDetailMedel?
    var jobId = ""
    var dispatcherId = ""
    var driverId = ""
    var gameTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate=self
        
        print(self.fromTrackDriver)
        
        if self.fromTrackDriver == "yes"
        {
            gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
            refrshBtn.isHidden=false
            if !(NetworkEngine.networkEngineObj.isInternetAvailable())
            {
                NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
            }
            else
            {
                self.JobDetalsAPI()
            }
        }
        else
        {
            refrshBtn.isHidden=true
            if self.sourceLat != "" && self.sourceLong != "" && self.destinationLat != "" && self.destinationLong != ""
            {
                showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D(latitude: Double(sourceLat)!, longitude: Double(sourceLong)!), destinationCoordinate: CLLocationCoordinate2D(latitude: Double(destinationLat)!, longitude: Double(destinationLong)!))
            }
            
            
        }
        
        
        
        
        
    }
    @IBAction func MenuAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func refreshAct(_ sender: UIButton)
    {
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.JobDetalsAPI()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        gameTimer?.invalidate()
    }
    @objc func runTimedCode()
    {
        if !(NetworkEngine.networkEngineObj.isInternetAvailable())
        {
            NetworkEngine.networkEngineObj.showInterNetAlert(vc:self)
        }
        else
        {
            self.JobDetalsAPI()
        }
    }
    
    
    func getDirections(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: loc1))
        source.name = "Your Location"
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: loc2))
        destination.name = "Destination"
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        //sourceMapItem.name = self.sourceAdd
        
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        // destinationMapItem.name = self.destinationAdd
        let sourceAnnotation = MKPointAnnotation()
        
        sourceAnnotation.title = self.sourceAdd
        sourceAnnotation.subtitle = "Pick up"
        
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = self.destinationAdd
        destinationAnnotation.subtitle = "Drop Off"
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    // print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
        
    }
    
    //MARK:- JobDetalsAPI Api
    
    func JobDetalsAPI()
    {
        
        
        let params = ["jobId" : self.jobId,
                      "driverId" : self.driverId,
                      "dispatcherId" : self.dispatcherId]   as [String : String]
        
        ApiHandler.ModelApiPostMethod2(url: JOB_DETAILS_API, parameters: params) { (response, error) in
            
            if error == nil
            {
                let decoder = JSONDecoder()
                do
                {
                    self.JobDetailData = try decoder.decode(JobDetailMedel.self, from: response!)
                    
                    if self.JobDetailData?.code == "200"
                        
                    {
                        
                        
                        NetworkEngine.showToast(controller: self, message: self.JobDetailData?.message ?? "")
                    }
                    else
                    {
                        self.view.makeToast(self.JobDetailData?.message)
                        if self.JobDetailData?.data?.count ?? 0 > 0
                        {
                            let dict = self.JobDetailData?.data?[0]
                            
                            // self.amountTxt.isUserInteractionEnabled = false
                            
                            let driverId = dict?.driverId ?? ""
                            
                            
                            
                            self.sourceLat = dict?.puplatitude ?? ""
                            self.sourceLong = dict?.puplongitude ?? ""
                            
                            
                            
                            self.destinationLat = dict?.drplatitude ?? ""
                            self.destinationLong = dict?.drplongitude ?? ""
                            
                            
                            self.driverLat = dict?.driverlatitude ?? ""
                            self.driverLong = dict?.driverlongitude ?? ""
                            
                            if self.sourceLat != "" && self.sourceLong != "" && self.destinationLat != "" && self.destinationLong != ""
                            {
                                self.showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D(latitude: Double(self.sourceLat)!, longitude: Double(self.sourceLong)!), destinationCoordinate: CLLocationCoordinate2D(latitude: Double(self.destinationLat)!, longitude: Double(self.destinationLong)!))
                            }
                            if self.driverLat != "" && self.driverLong != ""
                            {
                                
                                self.annotation.coordinate = CLLocationCoordinate2D(latitude: Double(self.driverLat)!, longitude: Double(self.driverLong)!)
                                self.annotation.title = "Driver Location"
                                self.mapView.addAnnotation(self.annotation)
                                
                            }
                            
                        }
                        
            
                    }
                
                    
                }
                catch let error
                {
                    // self.view.makeToast(error.localizedDescription)
                    NetworkEngine.showToast(controller: self, message: error.localizedDescription)
                }
                
            }
            else
            {
                //self.view.makeToast(error)
                NetworkEngine.showToast(controller: self, message: error)
            }
        }
    }
}

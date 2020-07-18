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
    
    var sourceLat = "30.7041"
     var sourceLong = "76.1025"
     var destinationLat = "28.7041"
    var destinationLong = "77.1025"
    
    var sourceAdd = ""
       var destinationAdd = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate=self
       
        
        if self.sourceLat != "" && self.sourceLong != "" && self.destinationLat != "" && self.destinationLong != ""
        {
          showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D(latitude: Double(sourceLat)!, longitude: Double(sourceLong)!), destinationCoordinate: CLLocationCoordinate2D(latitude: Double(destinationLat)!, longitude: Double(destinationLong)!))
        }
        
        
        
        
    }
    @IBAction func MenuAct(_ sender: UIButton)
        {
           self.navigationController?.popViewController(animated: true)
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
}

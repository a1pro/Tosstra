//
//  ChooseAddressVC.swift
//  Tosstra
//
//  Created by Eweb on 17/07/20.
//  Copyright © 2020 Eweb. All rights reserved.
//


import UIKit
import KYDrawerController
import MapKit


protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}
class ChooseAddressVC: UIViewController,UISearchBarDelegate {
    
    var searchController: UISearchController!
    @IBOutlet weak var searchTxt: UISearchBar!
    @IBOutlet var myTable:UITableView!
    var viewProfiledata:ViewProfileModel?
    var titleArray = ["Term & Conditions","Privacy Policy","Contact Us","Help","Change Password","Delete Account","Log Out"]
    
    var DisIconArray = ["term&conditions","Privacy-policy","Contact-us","Help","Privacy-policy","Delete-icon","Log-out"]
    
    var geocoder:CLGeocoder?
    var strings: [String]?
    weak var handleMapSearchDelegate: HandleMapSearch?
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate=self
        myTable.dataSource=self
        
        
        
        self.searchTxt.delegate=self
        
        //        searchController = UISearchController(searchResultsController: nil)
        //           searchController.searchResultsUpdater = self
        //
        //           // If we are using this same view controller to present the results
        //           // dimming it out wouldn't make sense. Should probably only set
        //           // this to yes if using another controller to display the search results.
        //           searchController.dimsBackgroundDuringPresentation = false
        //
        //           searchController.searchBar.sizeToFit()
        //           myTable.tableHeaderView = searchController.searchBar
        //
        //           // Sets this view controller as presenting view controller for the search interface
        //           definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden=true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden=true
    }
    @IBAction func MenuAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func parseAddress(selectedItem:MKPlacemark) -> String {
        
        
        print(selectedItem)
        
        let addressLine1 = (selectedItem.name ?? "")+" "+(selectedItem.locality ?? "")
        let addressLine2 = (selectedItem.subAdministrativeArea ?? "")+" "+(selectedItem.administrativeArea ?? "")
        let addressLine3 = ( selectedItem.country ?? "")+" "+(selectedItem.postalCode ?? "")
        
        return addressLine1+" "+addressLine2+" "+addressLine3
    }
    
}
extension ChooseAddressVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return matchingItems.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        let selectedItem = matchingItems[indexPath.row].placemark
        
        
        
        DEFAULT.set(parseAddress(selectedItem: selectedItem), forKey: "CHOOSENLOC")
        DEFAULT.set("\(selectedItem.coordinate.latitude)", forKey: "CHOOSENLAT")
        DEFAULT.set("\(selectedItem.coordinate.longitude)", forKey: "CHOOSENLONG")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchBarText = searchBar.text!
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
        //request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.myTable.reloadData()
        }
    }
}


extension ChooseAddressVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBarText = searchController.searchBar.text!
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        //request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.myTable.reloadData()
        }
        
        
    }
    
    func performSearch(for string: String) {
        // strings = nil
        myTable.reloadData()
        
        if geocoder?.isGeocoding ?? false { geocoder?.cancelGeocode() }
        
        geocoder?.geocodeAddressString(string) { placemarks, error in
            guard let placemarks = placemarks, error == nil, placemarks.count > 0 else {
                print("none found")
                return
            }
            
            self.strings = placemarks.map
                {
                    [$0.subLocality, $0.locality, $0.administrativeArea, $0.country]
                        .flatMap { $0 }
                        .joined(separator: ", ")
                    
                    
            }
            self.myTable.reloadData()
        }
    }
}
extension ChooseAddressVC {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
}

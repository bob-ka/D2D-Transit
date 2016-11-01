//
//  ViewController.swift
//  D2D Transit
//
//  Created by Bob K on 10/28/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SVGKit
class RoutesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, sideMenuViewControllerDelegate, UITextFieldDelegate, GMSAutocompleteResultsViewControllerDelegate, UISearchBarDelegate {
    @IBOutlet var legendsView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var legendsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var routesTableView: UITableView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var busImage: SVGKFastImageView!
    @IBOutlet weak var subwayImage: SVGKFastImageView!
    @IBOutlet weak var taxiImage: SVGKFastImageView!
    @IBOutlet weak var parkingImage: SVGKFastImageView!
    @IBOutlet weak var drivingImage: SVGKFastImageView!
    @IBOutlet weak var cyclingImage: SVGKFastImageView!
    var selectedTextField: UITextField?
    var fromPlaceSelected: GMSPlace?
    var toPlaceSelected: GMSPlace?
    var resultText: UITextView?
    var fetcher: GMSAutocompleteFetcher?
    var routes: [Route]!
    var currentPolyLine: GMSPolyline?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    //var updateDatatimer: Timer!
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        routes = DataManager.sharedInstance.savedRoutes
        (self.sideMenuViewController?.leftMenuViewController as! SideMenuViewController).delegate = self
        createMapView()
        createSearchBar()
        displayLegend()
        //updateDatatimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(RoutesViewController.updateData(sender:)), userInfo: nil, repeats: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !searchController!.isActive
        {
            searchController?.searchBar.frame.origin.y = -44
            searchViewTopLayoutConstraint.constant = 0
        }
    }
    
    //MARK: - tableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.routesTableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath) as! RouteTableViewCell
        let routeAtIndex = routes[indexPath.row]
        cell.providerTitleLabel.text = routeAtIndex.vehicleName() != nil ? routeAtIndex.type + " ( \(routeAtIndex.vehicleName()!) )" : routeAtIndex.type
        cell.fromLabel.text = routeAtIndex.fromOrigin()
        cell.toLabel.text = routeAtIndex.toDestination()
        cell.priceLabel.text = routeAtIndex.price
        let getGoingData = routeAtIndex.getGoingLabel()
        cell.getGoingLabel.text = getGoingData.text
        cell.getGoingLabel.textColor = getGoingData.color
        //cell.providerImageView.image = SVGKImage(contentsOf: URL(string:routeAtIndex.segments.last!.icon!))
        return cell
    }
    
    //MARK: - tableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toRouteDetails", sender: routes[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  120
    }
    
    //MARK: - Left SideMenu Bar Button Pressed
    @IBAction func presentLeftSideMenu(_ sender: UIBarButtonItem) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    //MARK: - sideMenu Delegate Methods
    func menuSelectedWithIndex(index: Int) {
        
        if index == 0
        {
            self.performSegue(withIdentifier: "toFavorites", sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "toProviders", sender: nil)
        }
    }
    
    //MARK: - textField Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        OperationQueue.main.addOperation {
            self.searchController!.searchBar.becomeFirstResponder()
            self.searchController?.searchBar.text = textField.text
            self.searchController?.isActive = true
        }
        searchController?.searchBar.frame.origin.y = 0
        searchViewTopLayoutConstraint.constant = -36
        selectedTextField = textField
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.fromTextField.resignFirstResponder()
        self.toTextField.resignFirstResponder()
        return true
    }
    @IBAction func editingChanged(_ sender: UITextField) {
        fetcher?.sourceTextHasChanged(sender.text)
    }
    
    //MARK: - AutoCompleteResults Delegate Methods
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        selectedTextField?.text = place.name
        if selectedTextField == toTextField
        {
            toPlaceSelected = place
        }
        else
        {
            fromPlaceSelected = place
        }
        // Do something with the selected place.
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        drawPolyLineBetweenPlaces()
    }
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        print(error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //MARK: - searchBar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        selectedTextField?.text = searchBar.text
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        selectedTextField?.text = ""
    }
    
    //MARK: - Update Data Timer Selector
    //This fuction will update the routes every 30 seconds in case there was a real backend
    /*func updateData (sender: Timer)
    {
     
        routes = DataManager.sharedInstance.savedRoutes
        self.routesTableView.reloadData()
    }*/
    //MARK: - Helper Methods
    func createMapView()
    {
        let camera = GMSCameraPosition.camera(withLatitude: 52.5200,longitude:13.4050, zoom:5)
        self.mapView.camera = camera
    }
    func createSearchBar()
    {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.delegate = self
        self.view.addSubview(searchController!.searchBar)
        searchController?.searchBar.frame.origin.y = -44
        self.definesPresentationContext = true
    }
    func drawPolyLineBetweenPlaces()
    {
        if fromPlaceSelected != nil && toPlaceSelected != nil
        {
            
            let path = GMSMutablePath()
            path.add(CLLocationCoordinate2D(latitude: fromPlaceSelected!.coordinate.latitude, longitude: fromPlaceSelected!.coordinate.longitude))
            path.add(CLLocationCoordinate2D(latitude: toPlaceSelected!.coordinate.latitude, longitude: toPlaceSelected!.coordinate.longitude))
            
            if currentPolyLine == nil
            {
                currentPolyLine = GMSPolyline(path: path)
            }
            else
            {
                currentPolyLine?.path = path
            }
            currentPolyLine!.strokeColor = UIColor.blue
            currentPolyLine!.strokeWidth = 5
            currentPolyLine!.map = self.mapView
            // set the camera at the midpoint and zoom according to distance
            
            let bounds = GMSCoordinateBounds(path: path)
            let cameraUpdate = GMSCameraUpdate.fit(bounds)
            self.mapView.moveCamera(cameraUpdate)
        }
    }
    func displayLegend()
    {
        self.busImage.image = SVGKImage(contentsOf: URL(string:"https://d3m2tfu2xpiope.cloudfront.net/vehicles/bus.svg"))
        self.subwayImage.image = SVGKImage(contentsOf: URL(string:"https://d3m2tfu2xpiope.cloudfront.net/vehicles/subway.svg"))
        self.taxiImage.image = SVGKImage(contentsOf: URL(string:"https://d3m2tfu2xpiope.cloudfront.net/vehicles/taxi.svg"))
        self.parkingImage.image = SVGKImage(contentsOf: URL(string:"https://d3m2tfu2xpiope.cloudfront.net/vehicles/parking.svg"))
        self.drivingImage.image = SVGKImage(contentsOf: URL(string:"https://d3m2tfu2xpiope.cloudfront.net/vehicles/driving.svg"))
        self.cyclingImage.image = SVGKImage(contentsOf: URL(string:"https://d3m2tfu2xpiope.cloudfront.net/vehicles/cycling.svg"))
        self.routesTableView.tableHeaderView = legendsView
        self.routesTableView.tableHeaderView?.frame.size.height = 50
    }
    
    //MARK: - Navigation Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRouteDetails"
        {
            let routeDetailsVC = segue.destination as! RouteDetailViewController
            routeDetailsVC.route = sender as! Route
        }
    }
}


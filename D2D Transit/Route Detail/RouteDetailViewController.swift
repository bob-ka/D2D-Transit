//
//  RouteDetailViewController.swift
//  D2D Transit
//
//  Created by Bob K on 10/29/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit
import GoogleMaps

class RouteDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    @IBOutlet weak var routeDetailstableView: UITableView!
    var route: Route!
    var routeDetailArray: [RouteDetail]!
    var displayedArray: [RouteDetail]!
    var mapView:GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = route.vehicleName() != nil ? route.type + " ( \(route.vehicleName()!) )" : route.type
        self.routeDetailstableView.estimatedRowHeight = 90
        self.routeDetailstableView.rowHeight = UITableViewAutomaticDimension
        routeDetailArray = route.routeToArrayOfDetails()
        displayedArray = routeDetailArray
        if DataManager.sharedInstance.favouritesContainRouteWhereRoute(route: route)
        {
            favoriteBarButton.title = "Unfavorite"
        }
        else
        {
            favoriteBarButton.title = "Favorite"
        }
        createMapView()
        self.routeDetailstableView.tableHeaderView = self.mapView
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - tableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeDetailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let routeDetailAtIndex = (routeDetailArray[indexPath.row])
        let cell = self.routeDetailstableView.dequeueReusableCell(withIdentifier: routeDetailAtIndex.routeCellType, for: indexPath)
        switch routeDetailAtIndex.routeCellType  {
        case "bigRouteOriginCell":
            (cell as! BigRouteOriginTableViewCell).originLabel.text = routeDetailAtIndex.originDestination
            (cell as! BigRouteOriginTableViewCell).routeView.backgroundColor = routeDetailAtIndex.color
            (cell as! BigRouteOriginTableViewCell).startPointView.backgroundColor = routeDetailAtIndex.color
            (cell as! BigRouteOriginTableViewCell).timeLabel.text = routeDetailAtIndex.time
            (cell as! BigRouteOriginTableViewCell).routeLabel.text = routeDetailAtIndex.travelModeToDestination
            (cell as! BigRouteOriginTableViewCell).stopsLabel.text = routeDetailAtIndex.numberOfStopsTitle
            (cell as! BigRouteOriginTableViewCell).downArrowLabel.text = routeDetailAtIndex.isExpanded! ? "▲" : "▼"
            //(cell as! BigRouteOriginTableViewCell).vehicleImage.image = SVGKImage(contentsOf: URL(string:routeDetailAtIndex.imageViewString!))
            break
        case "smallRouteOriginCell":
            (cell as! SmallRouteOriginTableViewCell).originLabel.text = routeDetailAtIndex.originDestination
            (cell as! SmallRouteOriginTableViewCell).routeView.backgroundColor = routeDetailAtIndex.color
            (cell as! SmallRouteOriginTableViewCell).startPointView.backgroundColor = routeDetailAtIndex.color
            (cell as! SmallRouteOriginTableViewCell).timeLabel.text = routeDetailAtIndex.time
            //(cell as! BigRouteOriginTableViewCell).routeLabel.text = routeDetailAtIndex.originDestination! + " -> " + (routeDetailArray[indexPath.row + 2] as! RouteDetail).originDestination!
            (cell as! SmallRouteOriginTableViewCell).stopsLabel.text = routeDetailAtIndex.numberOfStopsTitle
            //(cell as! BigRouteOriginTableViewCell).vehicleImage.image = SVGKImage(contentsOf: URL(string:routeDetailAtIndex.imageViewString!))
            break
        case "routeStopCell":
            (cell as! RouteStopTableViewCell).timeLabel.text = routeDetailAtIndex.time
            (cell as! RouteStopTableViewCell).routeView.backgroundColor = routeDetailAtIndex.color
            (cell as! RouteStopTableViewCell).stopAddressLabel.text = routeDetailAtIndex.stopAddress
            //(cell as! BigRouteOriginTableViewCell).vehicleImage.image = SVGKImage(contentsOf: URL(string:routeDetailAtIndex.imageViewString!))
            break
        default:
            (cell as! RouteDestinationTableViewCell).propertyLabel.text = routeDetailAtIndex.property
            (cell as! RouteDestinationTableViewCell).providerLabel.text = routeDetailAtIndex.provider
            (cell as! RouteDestinationTableViewCell).destinationLabel.text = routeDetailAtIndex.originDestination
            (cell as! RouteDestinationTableViewCell).timeLabel.text = routeDetailAtIndex.time
            (cell as! RouteDestinationTableViewCell).startPointView.backgroundColor = routeDetailAtIndex.color
            (cell as! RouteDestinationTableViewCell).routeView.backgroundColor = routeDetailAtIndex.color
            (cell as! RouteDestinationTableViewCell).vehicleHeightConstraint.constant = 0
            //(cell as! BigRouteOriginTableViewCell).vehicleImage.image = SVGKImage(contentsOf: URL(string:routeDetailAtIndex.imageViewString!))
            break
        }
        return cell
    }
    
    //MARK: - tableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routeDetailAtselectedRow  = routeDetailArray[indexPath.row]
        if routeDetailAtselectedRow.routeCellType == RouteDetail.cellType.bigRouteOrigin.rawValue
        {
            if routeDetailAtselectedRow.isExpanded!
            {
                //collapsing all stops
                var indexPathArray = [IndexPath]()
                for index in indexPath.row + 1 ..< indexPath.row + 1 + routeDetailAtselectedRow.stopsArray!.count
                {
                    indexPathArray.append(IndexPath(row: index, section:0))
                    self.routeDetailArray.remove(at: indexPath.row + 1)
                }
                self.routeDetailstableView.deleteRows(at: indexPathArray, with: .none)
                routeDetailAtselectedRow.isExpanded = false
            }
            else
            {
                // expanding all stops
                var indexPathArray = [IndexPath]()
                for index in indexPath.row + 1 ..< indexPath.row + 1 + routeDetailAtselectedRow.stopsArray!.count
                {
                    indexPathArray.append(IndexPath(row: index, section:0))
                    self.routeDetailArray.insert(routeDetailAtselectedRow.stopsArray![index - (indexPath.row + 1)], at: index)
                }
                self.routeDetailstableView.insertRows(at: indexPathArray, with: .none)
                routeDetailAtselectedRow.isExpanded = true
            }
            self.routeDetailstableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    //MARK: - Buttons
    @IBAction func favoriteBarButtonPressed(_ sender: UIBarButtonItem) {
        if sender.title! == "Unfavorite"
        {
            DataManager.sharedInstance.removeRouteFromFavoritesById(iD: route.iD)
            sender.title = "Favorite"
        }
        else
        {
            DataManager.sharedInstance.addRouteToUserFavoriteWhereRoute(route: route)
            sender.title = "Unfavorite"
        }
    }
    
    //MARK: - helper Method
    func createMapView()
    {
        //create the mapview and set the camera at the first coordinate in the first segment
        let firstSegment = route.segments.first
        if let thePolyLine = firstSegment!.polyline
        {
            let path = GMSPath(fromEncodedPath: thePolyLine)
            let camera = GMSCameraPosition.camera(withLatitude: path!.coordinate(at: 0).latitude, longitude:path!.coordinate(at: 0).longitude, zoom:13)
            self.mapView = GMSMapView.map(withFrame: CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: 260), camera:camera)
            drawPolyline(withPolylineString: thePolyLine, andSegment: firstSegment!)
        }
        for i in 1 ..< route.segments.count
        {
            let currentSegment = route.segments[i]
            if let thePolyline = currentSegment.polyline
            {
                drawPolyline(withPolylineString: thePolyline, andSegment: currentSegment)
            }
        }
    }
    func drawPolyline(withPolylineString thePolyLine: String, andSegment theSegment: Segment)
    {
        let path = GMSPath(fromEncodedPath: thePolyLine)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = theSegment.color
        polyline.strokeWidth = 5.0
        polyline.map = self.mapView
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

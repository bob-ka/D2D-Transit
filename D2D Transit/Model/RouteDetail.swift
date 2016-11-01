//
//  RouteDetail.swift
//  D2D Transit
//
//  Created by Bob K on 10/29/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit

class RouteDetail: NSObject {
    
    enum cellType: String
    {
        case bigRouteOrigin = "bigRouteOriginCell"
        case smallRouteOrigin = "smallRouteOriginCell"
        case stop = "routeStopCell"
        case destination /*, destinationBig*/ = "routeDestinationCell"
        //case destinationBig = "routeDestinationBigCell"
    }
    var routeCellType: String
    var imageViewString: String?
    var originDestination: String?
    var numberOfStopsTitle: String?
    var stopAddress: String?
    var time: String
    var provider: String?
    var color: UIColor
    var isExpanded: Bool?
    var property: String?
    var stopsArray: [RouteDetail]?
    var travelModeToDestination: String?
    
    //MARK: - inits
    init(withCellType theCellType: cellType, ImageViewString theImageViewString: String?, andOriginOrDestinationTitle theOriginOrDestination: String?, andNumberOfStopsTitle theNumberOfStopsTitle: String?, andStopAddress theStopAddress: String?, andTime theTime: String, andProvider theProvider: String?,andColor theColor: UIColor ,andIsExpanded IsItExpanded: Bool?, andProperty theProperty: String?, andTravelModeToDestination theTravelModeToDestination: String?)
    {
        self.routeCellType = theCellType.rawValue
        self.imageViewString = theImageViewString
        self.originDestination = theOriginOrDestination
        self.numberOfStopsTitle = theNumberOfStopsTitle
        self.stopAddress = theStopAddress
        self.time = theTime
        self.provider = theProvider
        self.color = theColor
        self.isExpanded = IsItExpanded
        self.property = theProperty
        if theCellType.rawValue == "bigRouteOriginCell" || theCellType.rawValue == "smallRouteOriginCell"
        {
            stopsArray = [RouteDetail]()
        }
        self.travelModeToDestination = theTravelModeToDestination
    }
}

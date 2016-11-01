//
//  Route.swift
//  D2D Transit
//
//  Created by Bob K on 10/28/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit

class Route: NSObject,NSCoding{

    //Constants used in Coders, Decoders
    fileprivate let typeString = "type"
    fileprivate let providerString = "provider"
    fileprivate let segmentsString = "segments"
    fileprivate let priceString = "price"
    fileprivate let idString = "iD"
    
    var type: String
    var provider : String
    var segments : [Segment]
    var price: String?
    var iD: Int
    
    //MARK: - inits
    init(withProviderType theProviderType: String, andProvider theProvider: String, andSegments theSegments: [Segment], andPrice thePrice: String?, andID theId: Int)
    {
        self.type = theProviderType
        self.provider = theProvider
        self.segments = theSegments
        self.price = thePrice
        self.iD = theId
    }
    required init?(coder aDecoder: NSCoder) {
        self.type = aDecoder.decodeObject(forKey: typeString) as! String
        self.provider = aDecoder.decodeObject(forKey: providerString) as! String
        self.segments = aDecoder.decodeObject(forKey: segmentsString) as! [Segment]
        self.price = aDecoder.decodeObject(forKey: priceString) as? String
        self.iD = aDecoder.decodeInteger(forKey:idString)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.type, forKey: typeString)
        aCoder.encode(self.provider, forKey: providerString)
        aCoder.encode(self.segments, forKey: segmentsString)
        if let thePrice = self.price
        {
            aCoder.encode(thePrice , forKey: priceString)
        }
        aCoder.encode(self.iD, forKey: idString)
    }
    //MARK: - Instance Methods
    func fromOrigin() -> String?
    {
        // the first name that appears in the first stops is the origin
        // i.e if first stop has nil for a name, move to the next.. and so forth
        for segment in self.segments
        {
            for stop in segment.stops
            {
                if let name = stop.name
                {
                    return name
                }
            }
        }
        return nil
    }
    func toDestination() -> String?
    {
        //the name in the last stop is the destination 
        return self.segments.last?.stops.last?.name
    }
    func vehicleName() -> String?
    {
        // the first segment that has a name is the vehicle's name, whether bus nb or car sharing or bike.
        for segment in self.segments
        {
            if let name = segment.name
            {
                return name
            }
        }
        return nil
    }
    
    func routeToArrayOfDetails() -> [RouteDetail]
    {
        var arrayOfDetails = [RouteDetail]()
        for segment in self.segments
        {
            var routeOriginDetail: RouteDetail
            if segment.stops.count > 1  // if stops > 1 -> it's an expandable cell
            {
                let stopsKeyword = (segment.stops.count - 1) > 1 ? " stops" : " stop"
                 routeOriginDetail = RouteDetail(withCellType: .bigRouteOrigin, ImageViewString: segment.icon, andOriginOrDestinationTitle: segment.name, andNumberOfStopsTitle: String(segment.stops.count - 1) + stopsKeyword
                    , andStopAddress: nil, andTime: segment.stops.first!.displayedTime, andProvider: nil,andColor: segment.color,andIsExpanded: false, andProperty: nil,andTravelModeToDestination: segment.travelMode + " → " + segment.stops.last!.name!)
            }
            else
            {
                let stopsKeyword = (segment.stops.count - 1) > 1 ? " stops" : " stop"
                routeOriginDetail = RouteDetail(withCellType: .smallRouteOrigin, ImageViewString: segment.icon, andOriginOrDestinationTitle: segment.name, andNumberOfStopsTitle: String(segment.stops.count - 1) + stopsKeyword, andStopAddress: nil, andTime: segment.stops.first!.displayedTime, andProvider: nil,andColor: segment.color,andIsExpanded: nil, andProperty: nil,andTravelModeToDestination :nil)
            }
            
            
            // when adding stops, the last stop is the destination. i.e when there are n stops, we add n - 1 stops to an array and the nth stop becomes the destination
            var arrayOfStopsDetails = [RouteDetail]()
            for i in 0 ..< segment.stops.count - 1
            {
                let theStop = segment.stops[i]
                let stopDetail = RouteDetail(withCellType: .stop, ImageViewString: nil, andOriginOrDestinationTitle: nil, andNumberOfStopsTitle: nil, andStopAddress: theStop.name, andTime: theStop.displayedTime, andProvider: nil, andColor: segment.color, andIsExpanded: nil, andProperty: nil, andTravelModeToDestination:nil)
                arrayOfStopsDetails.append(stopDetail)
            }
            
            routeOriginDetail.stopsArray = arrayOfStopsDetails
            arrayOfDetails.append(routeOriginDetail)
            
            //last stop is destination
            let lastStop = segment.stops.last
            let destinationRouteDetail = RouteDetail(withCellType: .destination, ImageViewString: nil, andOriginOrDestinationTitle: lastStop?.name, andNumberOfStopsTitle: nil, andStopAddress: nil, andTime: (lastStop?.displayedTime)!, andProvider: nil, andColor: segment.color, andIsExpanded: nil, andProperty: nil, andTravelModeToDestination:nil)
            
            arrayOfDetails.append(destinationRouteDetail)
        }
        return arrayOfDetails
    }
    func getGoingLabel() -> (color:UIColor, text: String)
    {
        /* Get going - 3 cases
         case 1: > 20 minutes => Relax - green color
         case 2: < 20 minutes => get going - red
         case 3 : < 0 minutes => missed - gray */
        let differenceBetweenTimeFirstStopAndCurrentDate = self.segments.first!.stops.first!.date!.timeIntervalSince(Date())
        if differenceBetweenTimeFirstStopAndCurrentDate > 1200
        {
            return (UIColor.green, "Relax")
        }
        else if differenceBetweenTimeFirstStopAndCurrentDate < 0
        {
            return (UIColor.gray, "Missed")
        }
        else
        {
            return (UIColor.red, "Get\nGoint")
        }
    }
}

//
//  Segment.swift
//  D2D Transit
//
//  Created by Bob K on 10/28/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit

class Segment: NSObject,NSCoding{
    
    //Constants used in Coders, Decoders
    fileprivate let nameString = "name"
    fileprivate let numOfStopsString = "numberOfStops"
    fileprivate let stopsString = "stops"
    fileprivate let travelModeString = "travelMode"
    fileprivate let descriptionString = "description"
    fileprivate let colorString = "color"
    fileprivate let iconString = "icon"
    fileprivate let polylineString = "polyLine"
    
    var name: String?
    var numberOfStops : Int
    var stops : [Stop]
    var travelMode: String
    var theDescription: String?
    var color: UIColor
    var icon: String?
    var polyline: String?
    
    //MARK: - inits
    init(withName theName : String?, andNumberOfStops theNumberOfStops: Int, andStops theStops : [Stop], andTravelMode thetTravelMode: String,andDescription descript: String? ,andColor theColor: UIColor,andIcon theIcon: String?, andPolyline thePolyline: String?)
    {
        self.name = theName
        self.numberOfStops = theNumberOfStops
        self.stops = theStops
        self.travelMode = thetTravelMode
        self.theDescription = descript
        self.color = theColor
        self.icon = theIcon
        self.polyline = thePolyline
    }
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: nameString) as? String
        self.numberOfStops = aDecoder.decodeInteger(forKey: numOfStopsString)
        self.stops = aDecoder.decodeObject(forKey: stopsString) as! [Stop]
        self.travelMode = aDecoder.decodeObject(forKey: travelModeString) as! String
        self.theDescription = aDecoder.decodeObject(forKey: descriptionString) as? String
        self.color = aDecoder.decodeObject(forKey: colorString) as! UIColor
        self.icon = aDecoder.decodeObject(forKey: iconString) as? String
        self.polyline = aDecoder.decodeObject(forKey: polylineString) as? String
    }
    func encode(with aCoder: NSCoder) {
        if let theName = self.name
        {
        aCoder.encode(theName, forKey: nameString)
        }
        aCoder.encode(self.numberOfStops, forKey: numOfStopsString)
        aCoder.encode(self.stops, forKey: stopsString)
        aCoder.encode(self.travelMode , forKey: travelModeString)
        if let descript = self.theDescription
        {
            aCoder.encode(descript , forKey: descriptionString)
        }
        aCoder.encode(self.color , forKey: colorString)
        //check If icon not nil, If so encode it
        if let theIcon = self.icon
        {
            aCoder.encode(theIcon , forKey: iconString)
        }
        if let thePolyline = self.polyline
        {
        aCoder.encode(thePolyline , forKey: polylineString)
        }
    }
}

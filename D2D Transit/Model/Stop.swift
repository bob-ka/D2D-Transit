//
//  Stop.swift
//  D2D Transit
//
//  Created by Bob K on 10/28/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit

class Stop: NSObject, NSCoding {
    
    //Constants used in Coders, Decoders
    fileprivate let latString = "lat"
    fileprivate let lngString = "lng"
    fileprivate let displayedTimeString = "dateTime"
    fileprivate let nameString = "name"
    fileprivate let dateString = "date"
    
    var lat: Double
    var lng : Double
    var displayedTime : String!
    var date: Date!
    var name: String?
    
    //MARK: - inits
    init(withLat theLat: Double, andLongitude theLongitude: Double, andDisplayedTime theDisplayedTime: String, andName theName: String?, andDate theDate: Date)
    {
        self.lat = theLat
        self.lng = theLongitude
        self.displayedTime = theDisplayedTime
        self.name = theName
        self.date = theDate
    }
    required init?(coder aDecoder: NSCoder) {
        self.lat = aDecoder.decodeDouble(forKey: latString)
        self.lng = aDecoder.decodeDouble(forKey: lngString)
        self.displayedTime = aDecoder.decodeObject(forKey: displayedTimeString) as! String
        self.name = aDecoder.decodeObject(forKey: nameString) as? String
        self.date = aDecoder.decodeObject(forKey:dateString) as! Date
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.lat, forKey: latString)
        aCoder.encode(self.lng, forKey: lngString)
        aCoder.encode(self.displayedTime, forKey: displayedTimeString)
        if let theName = self.name
        {
            aCoder.encode(theName , forKey: nameString)
        }
        aCoder.encode(self.date,forKey: dateString)
    }
}

//
//  DataManager.swift
//  D2D Transit
//
//  Created by Bob K on 10/28/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    var savedRoutes: [Route]!
    var savedProviders: [Provider]!
    var favouritesArray: [Route]!
    
    override init() {
        super.init()
        //check if savedRoutes exists, else read from file
        if let theSavedRoutes =  NSKeyedUnarchiver.unarchiveObject(withFile: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "routesData.RR")
        {
            self.savedRoutes = theSavedRoutes as! [Route] // if savedRoutes exist, then savedProviders exist
            self.savedProviders = NSKeyedUnarchiver.unarchiveObject(withFile: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "providerData.providers") as! [Provider]
            self.favouritesArray = NSKeyedUnarchiver.unarchiveObject(withFile: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "favorites.favor") as? [Route]
        }
        else // getData and save it
        {
            getData()
        }
    }
    
    //MARK: - Get Data From JSON File
    func getData()
    {
        var providersArray = [Provider]()
        var routesArray = [Route]()
        do
        {
            let routesData = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "RoutesData", ofType: "json")!))
            do
            {
                let parsedJson = try JSONSerialization.jsonObject(with: routesData, options: JSONSerialization.ReadingOptions.mutableContainers)
                let parsedRoutesArray = ((parsedJson as! NSDictionary)["routes"] as! NSArray)
                var currentRoute = 0
                for aRoute in parsedRoutesArray
                {
                    let routeDictionary = aRoute as! [String: Any]
                    var segmentsArray = [Segment]()
                    for aSegment in routeDictionary["segments"] as! NSArray
                    {
                        let segmentDictionary = aSegment as! [String: Any]
                        var stopsArray = [Stop]()
                        for aStop in segmentDictionary["stops"] as! NSArray
                        {
                            let stopDictionary = aStop as! [String: Any]
                            let stop = Stop(withLat: stopDictionary["lat"] as! Double, andLongitude: stopDictionary["lng"] as! Double, andDisplayedTime: timeFromDateString(dateString: stopDictionary["datetime"] as! String).timeString , andName: stopDictionary["name"] as? String, andDate:timeFromDateString(dateString: stopDictionary["datetime"] as! String).date)
                            stopsArray.append(stop)
                        }
                        let segment = Segment(withName: segmentDictionary["name"] as? String, andNumberOfStops: segmentDictionary["num_stops"] as! Int, andStops: stopsArray, andTravelMode: segmentDictionary["travel_mode"] as! String, andDescription: segmentDictionary["description"] as? String, andColor: hexStringToUIColor(segmentDictionary["color"] as! String) , andIcon: segmentDictionary["icon_url"] as? String, andPolyline: segmentDictionary["polyline"] as? String)
                        segmentsArray.append(segment)
                    }
                    var price: String?
                    if let priceDictionary = routeDictionary["price"] as? [String:Any]
                    {
                        price = String(priceDictionary["amount"] as! Int) + "\n" + (priceDictionary["currency"] as!String)
                    }
                    let route = Route(withProviderType: routeDictionary["type"] as! String, andProvider: routeDictionary["provider"] as! String, andSegments: segmentsArray, andPrice: price, andID: currentRoute)
                    routesArray.append(route)
                    currentRoute += 1
                }
                let parsedProvidersDictionary = ((parsedJson as! NSDictionary)["provider_attributes"] as! NSDictionary)
                for key in parsedProvidersDictionary.allKeys
                {
                    let providerDetailsDictionary = parsedProvidersDictionary[key] as! [String:String]
                    let provider = Provider(withName: key as! String, andIcon: providerDetailsDictionary["provider_icon_url"], andDisplayName: providerDetailsDictionary["display_name"], andDisclaimer: providerDetailsDictionary["disclaimer"]!)
                    providersArray.append(provider)
                }
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        //Save data
        NSKeyedArchiver.archiveRootObject(routesArray, toFile: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "routesData.RR")
        NSKeyedArchiver.archiveRootObject(providersArray, toFile: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "providerData.providers")
        // populate instance variables
        self.savedRoutes = routesArray
        self.savedProviders = providersArray
    }
    
    //MARK: - Helper Methods
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func timeFromDateString(dateString: String) -> (date: Date, timeString: String)
    {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let parsedDate = inputDateFormatter.date(from: dateString)
        let outputTimeDateFormatter = DateFormatter()
        outputTimeDateFormatter.dateFormat = "HH:mm"
        return (parsedDate!,outputTimeDateFormatter.string(from: parsedDate!))
    }
    //MARK: - Favorites Handling
    func saveFavourites()
    {
        NSKeyedArchiver.archiveRootObject(favouritesArray, toFile: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "favorites.favor")
    }
    func addRouteToUserFavoriteWhereRoute(route: Route)
    {
        if self.favouritesArray == nil
        {
            self.favouritesArray = [Route]()
        }
        self.favouritesArray!.append(route)
        saveFavourites()
    }
    func removeRouteFromFavoritesById(iD: Int)
    {
        var index = 0
        for route in self.favouritesArray!
        {
            if route.iD == iD
            {
                self.favouritesArray!.remove(at: index)
            }
            index += 1
        }
        saveFavourites()
    }
    func favouritesContainRouteWhereRoute(route: Route) -> Bool
    {
        if let favoriteRoutes = self.favouritesArray
        {
            var index = 0
            for theRoute in favoriteRoutes
            {
                if theRoute.iD == route.iD
                {
                    return true
                }
                index += 1
            }
            return false
        }
        else
        {
            return false
        }
    }
}

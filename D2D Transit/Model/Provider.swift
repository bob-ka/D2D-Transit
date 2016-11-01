//
//  Provider.swift
//  D2D Transit
//
//  Created by Bob K on 10/28/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import UIKit


class Provider: NSObject, NSCoding {
    
    //Constants used in Coders, Decoders
    fileprivate let nameString = "name"
    fileprivate let iconString = "icon"
    fileprivate let displayNameString = "displayName"
    fileprivate let disclaimerString = "disclaimer"
    
    var name: String!
    var icon: String?
    var displayName : String?
    var disclaimer : String!
    
    //MARK: - inits
    init(withName theName: String, andIcon theIcon: String?, andDisplayName theDisplayName: String?, andDisclaimer theDisclaimer: String)
    {
        self.name = theName
        self.icon = theIcon
        self.displayName = theDisplayName
        self.disclaimer = theDisclaimer
    }
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: nameString) as? String
        self.icon = aDecoder.decodeObject(forKey: iconString) as? String
        self.displayName = aDecoder.decodeObject(forKey: displayNameString) as? String
        self.disclaimer = aDecoder.decodeObject(forKey: disclaimerString) as! String
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: nameString)
        if let theIcon = self.icon
        {
            aCoder.encode(theIcon, forKey: iconString)
        }
        if let theDisplayName = self.displayName
        {
            aCoder.encode(theDisplayName, forKey: displayNameString)
        }
        aCoder.encode(self.disclaimer, forKey: disclaimerString)
    }
}

//
//  D2D_TransitTests.swift
//  D2D TransitTests
//
//  Created by Bob K on 10/28/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import XCTest
@testable import D2D_Transit

class D2D_TransitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: Hex to Color Test
    func testHexToUIColor()
    {
        XCTAssertEqual( UIColor(red: 0, green: 0, blue: 0, alpha: 1.0), DataManager.sharedInstance.hexStringToUIColor("#000000"))
        XCTAssertEqual( UIColor(red: 1, green: 1, blue: 1, alpha: 1.0), DataManager.sharedInstance.hexStringToUIColor("#ffffff"))
        XCTAssertEqual( UIColor(red: 66/255.0, green: 244/255.0, blue: 152/255.0, alpha: 1.0), DataManager.sharedInstance.hexStringToUIColor("#42f498"))
    }
    
    //MARK: - Route Tests
    func testRouteOrigin()
    {
        XCTAssertEqual(DataManager.sharedInstance.savedRoutes[4].fromOrigin(), "Torstraße 103, 10119 Berlin, Deutschland")
    }
    
    func testRouteDestination()
    {
        XCTAssertEqual(DataManager.sharedInstance.savedRoutes[4].toDestination(), "Leipziger Platz 7, 10117 Berlin, Deutschland")
    }
    
    func testRouteVehicleName()
    {
        XCTAssertEqual(DataManager.sharedInstance.savedRoutes[4].vehicleName(), nil)
        XCTAssertEqual(DataManager.sharedInstance.savedRoutes[0].vehicleName(), "U2")
    }
    
    //MARK: - Time Tests
    func testTimeFromDateString()
    {
        XCTAssertEqual(DataManager.sharedInstance.timeFromDateString(dateString: "2016-10-29T09:45:00.000+02:00 ").timeString, "11:45")
    }
    
}

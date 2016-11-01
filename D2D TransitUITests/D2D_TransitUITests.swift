//
//  D2D_TransitUITests.swift
//  D2D TransitUITests
//
//  Created by Bob K on 10/28/16.
//  Copyright © 2016 Ibrahim All rights reserved.
//

import XCTest

class D2D_TransitUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeleteFromDetailPageIsReflectedInFavorites()
    {
        //start with no favorites
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let uRosaLuxemburgPlatzStaticText = tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["U Rosa-Luxemburg-Platz"]
        uRosaLuxemburgPlatzStaticText.tap()
        
        let d2dTransitRoutedetailviewNavigationBar = app.navigationBars["D2D_Transit.RouteDetailView"]
        d2dTransitRoutedetailviewNavigationBar.buttons["Favorite"].tap()
        
        let d2dTransitButton = d2dTransitRoutedetailviewNavigationBar.buttons["D2D transit"]
        d2dTransitButton.tap()
        
        let button = app.navigationBars["D2D transit"].children(matching: .button).element
        button.tap()
        
        let favoritesStaticText = tablesQuery.staticTexts["❤️  Favorites "]
        favoritesStaticText.tap()
        XCTAssertTrue(tablesQuery.staticTexts["U Rosa-Luxemburg-Platz"].exists)
        app.navigationBars["Favourites"].buttons["D2D transit"].tap()
        uRosaLuxemburgPlatzStaticText.tap()
        d2dTransitRoutedetailviewNavigationBar.buttons["Unfavorite"].tap()
        d2dTransitButton.tap()
        button.tap()
        favoritesStaticText.tap()
        XCTAssertFalse(tablesQuery.staticTexts["U Rosa-Luxemburg-Platz"].exists)
    }
    
   func testDeleteFavoriteFromDetailPageInitiatedByFavoritePage()
   {
    // start with clean slate - no favourites
    let app = XCUIApplication()
    let tablesQuery = app.tables
    tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["U Rosa-Luxemburg-Platz"].tap()
    
    let d2dTransitRoutedetailviewNavigationBar = app.navigationBars["D2D_Transit.RouteDetailView"]
    d2dTransitRoutedetailviewNavigationBar.buttons["Favorite"].tap()
    d2dTransitRoutedetailviewNavigationBar.buttons["D2D transit"].tap()
    app.navigationBars["D2D transit"].children(matching: .button).element.tap()
    tablesQuery.staticTexts["❤️  Favorites "].tap()
    XCTAssertTrue(tablesQuery.staticTexts["U Rosa-Luxemburg-Platz"].exists)
    tablesQuery.staticTexts["U Rosa-Luxemburg-Platz"].tap()
    d2dTransitRoutedetailviewNavigationBar.buttons["Unfavorite"].tap()
    d2dTransitRoutedetailviewNavigationBar.buttons["Favourites"].tap()
    XCTAssertFalse(tablesQuery.staticTexts["U Rosa-Luxemburg-Platz"].exists)
    }
    
    
}

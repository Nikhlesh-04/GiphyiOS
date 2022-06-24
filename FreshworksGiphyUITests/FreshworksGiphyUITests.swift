//
//  FreshworksGiphyUITests.swift
//  FreshworksGiphyUITests
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import XCTest

class FreshworksGiphyUITests: XCTestCase {
    
    // NOTE: I create UI and Unit test cases for as API response, but we can also create UI and Unit test cases from create stub and Mock data.
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        // Since UI tests are more expensive to run, it's usually
        // a good idea to exit if a failure was encountered
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // We send the uitesting command line argument to the app to
        // reset its state and to use the alert analytics engine
        app.launchArguments.append("--uitesting")
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testLogin() {
        
        app.activate()
        app.launch()
        
        if app.buttons["Login"].exists {
            XCTAssertTrue(app.buttons["Login"].exists)
            XCTAssertTrue(app.staticTexts[ConstantsMessages.welcomeText].exists)
        }
    }
    
    func testLoginSucess() {
        
        app.activate()
        app.launch()
        
        if app.buttons["Login"].exists {
            app.buttons["Login"].tap()
            
            // Since this is an asynchronous bound operation, we'll wait for
            sleep(5)
            
            let table = app.tables[Identifiers.trendingTable]
            XCTAssertTrue(table.exists)
            XCTAssertGreaterThan(table.cells.count, 0)
        }
    }
    
    func testLogout() {
        app.activate()
        app.launch()
        
        if app.buttons["Login"].exists {
            app.buttons["Login"].tap()
        }
        
        // Since this is an asynchronous bound operation, we'll wait for
        sleep(2)
        
        XCTAssertTrue(app.buttons["Logout"].exists)
        
        app.buttons["Logout"].tap()
                
        let welcomelabel = app.staticTexts[ConstantsMessages.welcomeText]
        XCTAssertTrue(welcomelabel.waitForExistence(timeout: 2))
    }
    
    func testSearchGIF() {
        app.activate()
        app.launch()
        
        if app.buttons["Login"].exists {
            app.buttons["Login"].tap()
        }
        
        // Since this is an asynchronous bound operation, we'll wait for
        sleep(2)
        
        app.searchFields["Search"].tap()
        app.searchFields["Search"].typeText("H")
        app.searchFields["Search"].typeText("a")
        //Check show search cancel privious search performance
        Thread.sleep(forTimeInterval: 2)
        app.searchFields["Search"].typeText("p")
        app.searchFields["Search"].typeText("p")
        app.searchFields["Search"].typeText("y")
        
        sleep(5)
        
        let table = app.tables[Identifiers.trendingTable]
        XCTAssertTrue(table.exists)
        XCTAssertGreaterThan(table.cells.count, 0)
    }
    
    func testFavorite_OR_unFavorite_GIF() {
        app.activate()
        app.launch()
        
        if app.buttons["Login"].exists {
            app.buttons["Login"].tap()
        }
        
        // Since this is an asynchronous bound operation, we'll wait for
        sleep(2)
        
        let table = app.tables[Identifiers.trendingTable]
        XCTAssertTrue(table.exists)
        XCTAssertGreaterThan(table.cells.count, 0)
        let button = table.cells.element(boundBy: 0).buttons[Identifiers.favoriteButton]
        XCTAssertTrue(button.exists)
        
        button.tap()
        
        sleep(3)

        XCTAssertTrue(button.firstMatch.label == ConstantImage.favorite || button.firstMatch.label == ConstantImage.unfavorite)
    }
    
    func testSegment() {
        app.activate()
        app.launch()
        
        if app.buttons["Login"].exists {
            app.buttons["Login"].tap()
        }
        
        // Since this is an asynchronous bound operation, we'll wait for
        sleep(3)
        
        let favoriteTab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(favoriteTab.exists)
        
        favoriteTab.tap()
        
        sleep(2)
        
        XCTAssertTrue(app.segmentedControls.element.exists)
        
        let gridSegment = app.segmentedControls.buttons["Grid"]
        XCTAssertTrue(gridSegment.exists)
        
        let listSegment = app.segmentedControls.buttons["List"]
        XCTAssertTrue(listSegment.exists)
        
        listSegment.tap()
        
    }
    
    func testFavoriteSegmentUnFavoriteGIF() {
        app.activate()
        app.launch()
        
        if app.buttons["Login"].exists {
            app.buttons["Login"].tap()
        }
        
        // Since this is an asynchronous bound operation, we'll wait for
        sleep(3)
        
        let favoriteTab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(favoriteTab.exists)
        
        favoriteTab.tap()
        
        let collectionView = app.scrollViews
        XCTAssertTrue(collectionView.element.exists)
        
        if app.scrollViews.otherElements[Identifiers.cellImageView].exists {
            let oldCellCount = app.scrollViews.otherElements.matching(identifier: Identifiers.cellImageView).count
            let cellWithFavoriteButton = collectionView.otherElements.buttons.element(boundBy: 0)
            XCTAssertTrue(cellWithFavoriteButton.exists)
            
            cellWithFavoriteButton.tap()
            
            let newCellCount = app.scrollViews.otherElements.matching(identifier: Identifiers.cellImageView).count
            XCTAssertGreaterThan(oldCellCount, newCellCount)
            
        }
    }
}

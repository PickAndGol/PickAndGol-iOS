//
//  testPub.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 5/4/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import XCTest
import CoreLocation

class testPub: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class
        let session =  userSessionManager.sharedInstance
        let user = ["id":"123456","name":"prueba","email":"prueba@gmail.com","token":"987654321","photo_url":"http://pickandgol.com/photo_url"] as JSONDictionary
        session.initWithLogin(dict: user as JSONDictionary)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCreatePubName(){
    
        let location = CLLocation(latitude: 37.1, longitude: -4)
        let pub = PubModel(name: "Bar de Prueba", location:location)
        let data = pub.modelToDict()!

        XCTAssertEqual(data["name"], "Bar de Prueba", "Test Nombre")
    }
    func testCreatePubLocation(){
        
        let location = CLLocation(latitude: 37.1, longitude: -4.0)
        let pub = PubModel(name: "Bar de Prueba", location:location)
        let data = pub.modelToDict()!
        
        XCTAssertEqual(data["latitude"], "37.1", "Latitude")
        XCTAssertEqual(data["longitude"], "-4.0", "Longitude")
    }
    
}

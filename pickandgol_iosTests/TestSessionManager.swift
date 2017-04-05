//
//  TestSessionManager.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 5/4/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import XCTest

class TestSessionManager: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    func testInitSessionManager(){
        let session =  userSessionManager.sharedInstance
        let user = ["id":"123456","name":"prueba","email":"prueba@gmail.com","token":"987654321","photo_url":"http://pickandgol.com/photo_url"] as JSONDictionary
        session.initWithLogin(dict: user as JSONDictionary)
        XCTAssertEqual([session.getIdUser(),session.getUser(), session.getEmail(),session.getToken(),session.getUrlPhoto()!], ["123456","prueba","prueba@gmail.com","987654321","http://pickandgol.com/photo_url"], "Test init complete")
    }
    
    func testInitSessionLogged(){
        let session =  userSessionManager.sharedInstance
        let user = ["id":"123456","name":"prueba","email":"prueba@gmail.com","token":"987654321","photo_url":"http://pickandgol.com/photo_url"] as JSONDictionary
        session.initWithLogin(dict: user as JSONDictionary)
        XCTAssertTrue(session.logged)
    }
    
    func testInitSessionWithoutPhoto(){
        let session =  userSessionManager.sharedInstance
        let user = ["id":"123456","name":"prueba","email":"prueba@gmail.com","token":"987654321"] as JSONDictionary
        session.initWithLogin(dict: user as JSONDictionary)
        XCTAssertNil(session.getUrlPhoto())
    }
    
    func testInitSessionWithoutPhotoCompareFields(){
        let session =  userSessionManager.sharedInstance
        let user = ["id":"123456","name":"prueba","email":"prueba@gmail.com","token":"987654321"] as JSONDictionary
        session.initWithLogin(dict: user as JSONDictionary)
        XCTAssertEqual([session.getIdUser(),session.getUser(), session.getEmail(),session.getToken()], ["123456","prueba","prueba@gmail.com","987654321"], "testInitSessionWithoutPhotoCompareFields")
    }
    func testInitSessionNilLogged(){
        let session =  userSessionManager.sharedInstance
        let user = [:] as JSONDictionary
        session.initWithLogin(dict: user as JSONDictionary)
        XCTAssertFalse(session.logged)
    }
    func testInitSessionNilSession(){
        let session =  userSessionManager.sharedInstance
        let user = [:] as JSONDictionary
        session.initWithLogin(dict: user as JSONDictionary)
        XCTAssertNil(session.userSession)
    }
    
}

//
//  TestResponse.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 5/4/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import XCTest

class TestResponse: XCTestCase {
    
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
    
    func testInitResponse(){
        
        
        let itemsinfo = ["_id": "58d9276935c7620a944d53c2",
                         "name": "Gran Premio de Cheste",
                         "date": "2017-12-11T00:00:00.000Z",
                         "description": "Gran Premio de España",
                         "photo_url": "4TGtgDOCW99TofAHDfMy.jpg",
                         "creator": "58bf2143fbbcf94b0710d808","pubs": [
                            "58c5036a92b33d06a10ca1e7"
            ],
                         "category": [
                            "1"
            ]] as [String : Any]
        
        let dataInfo = ["total":67,"items":itemsinfo] as [String : Any]
        let dic = ["result":"OK","data":dataInfo] as [String : Any]
        let response = Response(dictionary: dic as JSONDictionary)
        
        XCTAssertTrue((response?.succeeded)!)
        
    }
    
    func testInitResponseOneItemPayLoad(){
        
        
        let itemsinfo = ["_id": "58d9276935c7620a944d53c2",
                         "name": "Gran Premio de Cheste",
                         "date": "2017-12-11T00:00:00.000Z",
                         "description": "Gran Premio de España",
                         "photo_url": "4TGtgDOCW99TofAHDfMy.jpg",
                         "creator": "58bf2143fbbcf94b0710d808","pubs": [
                            "58c5036a92b33d06a10ca1e7"
            ],
                         "category": [
                            "1"
            ]] as [String : Any]
        
        let dataInfo = ["total":67,"items":itemsinfo] as [String : Any]
        let dic = ["result":"OK","data":dataInfo] as [String : Any]
        let response = Response(dictionary: dic as JSONDictionary)!
        
        let resp = response.result()! as! JSONDictionary
        let dataResp = resp["items"] as! JSONDictionary
        
        XCTAssertEqual(["58d9276935c7620a944d53c2"], [dataResp["_id"] as! String], "Test Response")
        
    }
    
    func testInitResponseMoreThanOneItemPayLoad(){
        
        
        let itemsinfo = [
                        [
                         "_id": "58d9276935c7620a944d53c2",
                         "name": "Gran Premio de Cheste",
                         "date": "2017-12-11T00:00:00.000Z",
                         "description": "Gran Premio de España",
                         "photo_url": "4TGtgDOCW99TofAHDfMy.jpg",
                         "creator": "58bf2143fbbcf94b0710d808","pubs": [
                            "58c5036a92b33d06a10ca1e7"],
                         "category": ["1"]
                         ] as [String : Any],
                         [
                            "_id": "58c5a19492b33d06a10ca20e",
                            "name": "Manchester vs Liverpol",
                            "date": "2017-12-04T00:00:00.000Z",
                            "description": "Premier League",
                            "photo_url": "",
                            "pubs": ["58c53a9292b33d06a10ca1f4"],
                            "category": ["2"]
                        ] as [String : Any]
        ]
        
        let dataInfo = ["total":67,"items":itemsinfo] as [String : Any]
        let dic = ["result":"OK","data":dataInfo] as [String : Any]
        let response = Response(dictionary: dic as JSONDictionary)!
        
        let resp = response.results()! 
        let dataResp = resp[0]
        let dataResp1 = resp[1]
        
        XCTAssertEqual(["58d9276935c7620a944d53c2","58c5a19492b33d06a10ca20e"], [dataResp["_id"] as! String,dataResp1["_id"] as! String ], "Test Response")
        
    }
    
    
}

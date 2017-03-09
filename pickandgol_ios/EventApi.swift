//
//  EventApi.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 21/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation

typealias bodyType = [String:String]


class EventApi:NetworkResource {
    
    var path: URL = URL(string:"http://pickandgol.com/api/v1/events/")!
    var methodRequest:HTTPMethod = .get
    var body:bodyType = [:]
   
    init(path:URL, method methodRequest:HTTPMethod, body:bodyType){
        self.path = path
        self.methodRequest = methodRequest
        self.body = body
    }
    
}

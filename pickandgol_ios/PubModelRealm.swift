//
//  PubModelRealm.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 2/5/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RealmSwift



class PubModelRealm:Object {
    
    dynamic var pubId = UUID().uuidString
    dynamic var name = ""
    
    override class func primaryKey() -> String?{
        return "pubId"
    }
    
    override class func indexedProperties() -> [String] {
        return ["name"]
    }
    
       
   
    
}

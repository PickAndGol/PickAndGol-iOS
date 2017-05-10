//
//  PubModelRealm.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 2/5/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RealmSwift


class PubModelPhotoRealm:Object {
    dynamic var id = UUID().uuidString
    dynamic var photo = ""
    
    convenience init(photo:String) {
        self.init()
        self.photo = photo
    }
}

class PubModelEventRealm:Object {
    dynamic var id = UUID().uuidString
    dynamic var event = ""
    
    convenience init(event:String) {
        self.init()
        self.event = event
    }
}

class PubModelGpsRealm:Object {
    dynamic var id = UUID().uuidString
    dynamic var latitude:Double = 0.0
    dynamic var longitude:Double = 0.0
    
    convenience init(gps:Array<Double>) {
        self.init()
        self.latitude = gps[0]
        self.longitude = gps[1]
    }
    
    
}



class PubModelRealm:Object {
    
    dynamic var pubId = UUID().uuidString
    dynamic var name = ""
    dynamic var id = ""
    dynamic var ownerid = ""
    
    var photos = List<PubModelPhotoRealm>()
    var events = List<PubModelEventRealm>()
    var coordinates = List<PubModelGpsRealm>()
    
    
    override class func primaryKey() -> String?{
        return "pubId"
    }
    
    override class func indexedProperties() -> [String] {
        return ["name"]
    }
    
       
   
    
}



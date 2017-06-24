//
//  TimelineModelRealm.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 22/6/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import RealmSwift


class PubTimelineModel:Object {
    dynamic var id = UUID().uuidString
    dynamic var idEvent:String = ""
    dynamic var name:String = ""
    dynamic var date:String = ""
    dynamic var category:String = ""
    dynamic var photourl:String = ""
    dynamic var descriptionEvent:String = ""
    dynamic var creator:String = ""
    
    var pubs = List<pubsOfEvent>()
    

    convenience init(idEvent:String, name:String,date:String, category:String, photoUrl:String, description:String, creator:String) {
    
        self.init()
        self.idEvent = idEvent
        self.name = name
        self.date = date
        self.category = category
        self.photourl = photoUrl
        self.descriptionEvent = description
        self.creator = creator
        
        
    }
    
    convenience  init(name:String, descriptionEvent:String, photoUrl:String) {
        self.init()
        self.name = name
        self.descriptionEvent = descriptionEvent
        self.photourl = photoUrl
    }
    
    
    override class func primaryKey() -> String?{
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["name"]
    }

    

}


class pubsOfEvent:Object {
    
    dynamic var id = UUID().uuidString
    dynamic var idPubEvent = ""
    
    convenience init(idPub:String) {
        self.init()
        self.idPubEvent = idPub
    }
}

//
//  PubModelStruct.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import CoreLocation


struct PubModelStruct {
    
    let name:String
    let location:CLLocation
    let weburl:String
    let phone:String
    let photo:String

    init(namePub name:String, location:CLLocation, weburl:String,phone:String,photo:String){
        self.name = name
        self.location = location
        self.phone = phone
        self.weburl = weburl
        self.photo = photo
    }
    
    init(namePub name:String, location:CLLocation) {
        self.name = name
        self.location = location
        self.phone = ""
        self.weburl = ""
        self.photo = ""
    }
    
    init(dataPub:JSONDictionary){
        self.name = dataPub["name"] as! String
        self.location = dataPub["location"] as! CLLocation
        
        if let phone = dataPub["phone"] {
            self.phone = phone as! String
        } else {
            phone = ""
        }
        
        if let photo = dataPub["photo"] {
            self.photo = photo as! String
        } else {
            photo = ""
        }
        
        if let weburl = dataPub["weburl"] {
            self.weburl = weburl as! String
        } else {
            weburl = ""
        }
        
        
        
    }
    
    
}

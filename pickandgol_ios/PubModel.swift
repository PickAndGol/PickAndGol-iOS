//
//  PubModel.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import CoreLocation


class PubModel{
    
    var model:PubModelStruct
    let client = Client()
    
    init(name namePub:String, location:CLLocation){
        self.model = PubModelStruct(namePub:namePub, location:location)
        
    }
    
    init(namePub name:String, location:CLLocation, weburl:String,phone:String,photo:String){
        self.model = PubModelStruct(namePub: name, location: location, weburl: weburl, phone: phone, photo: photo)
    }
    
    
    init(data:JSONDictionary){
        self.model = PubModelStruct(dataPub: data)
    }
    
    func modelToDict() -> bodyType? {
        
        guard userSessionManager.sharedInstance.logged else  {
            return nil
        }
        
        return ["name":model.name,"latitude":String(model.location.coordinate.latitude) ,"longitude":String(model.location.coordinate.longitude),"photo_url":model.photo,"phone":model.phone,"url":model.weburl ,"user_id":userSessionManager.sharedInstance.getIdUser(), "token":userSessionManager.sharedInstance.getToken()]
        
        
    }
    
   
    
    
    
}

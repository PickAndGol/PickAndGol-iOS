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
    
    func modelToDict() -> bodyType? {
        
        guard userSessionManager.sharedInstance.logged else  {
            return nil
        }
        
        return ["name":model.name,"latitude":String(model.location.coordinate.latitude) ,"longitude":String(model.location.coordinate.longitude),"user_id":userSessionManager.sharedInstance.getIdUser(), "token":userSessionManager.sharedInstance.getToken()]
        
        
    }
    
   
    
    
    
}

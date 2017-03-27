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

    init(namePub name:String, location:CLLocation){
        self.name = name
        self.location = location
    }
    
    
}

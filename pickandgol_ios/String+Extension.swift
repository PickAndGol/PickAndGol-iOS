//
//  String+Extension.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 20/6/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation


extension String {
    
    func zuluToDate() -> String{
        
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: self)// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: date!)
        
    }
    
}


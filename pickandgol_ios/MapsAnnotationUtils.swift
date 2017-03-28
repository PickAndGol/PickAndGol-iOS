//
//  MapsAnnotationUtils.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 28/3/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import MapKit

class MapsAnnotationsUtils:NSObject,MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(coordinate:CLLocationCoordinate2D , title:String, subtitle:String ){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    
    
}


//
//  CurrentPositionUser.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 3/4/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import Foundation
import CoreLocation

class CurrentPositionUser:NSObject, CLLocationManagerDelegate {
    
    
    let posicion = CLLocationManager()
    var locationUser:CLLocation?
    
    
    static let sharedInstance = CurrentPositionUser()
    
    private override init(){
        super.init()
        posicion.requestAlwaysAuthorization()
        posicion.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        
        // Compruebo si tengo acceso a la localización
        
        if (!(status == CLAuthorizationStatus.denied) ){
            
            // Configuro el location manager
            
            posicion.delegate = self
            posicion.desiredAccuracy = kCLLocationAccuracyBest
            
            // Empieza a funcionar
            posicion.startUpdatingLocation()
            
            
            
        }else{
            print("No tienes autorizacion para ejecutar Location Manager")
        }
    }
    
    
    func getLatidude() -> Double {
        return (self.posicion.location?.coordinate.latitude)!
    }
    
    func getLongitud() -> Double {
        return (self.posicion.location?.coordinate.longitude)!
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        // Paramos que siga buscando la localiación. Consume mucha bateria
        
        self.posicion.stopUpdatingLocation()
        locationUser = latestLocation
        
        
        
        
    }
    
    
}
